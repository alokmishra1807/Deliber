import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:deliber/features/messaging/data/datasources/message_remote_datasource.dart';
import 'package:deliber/features/messaging/domain/entities/message_entity.dart';
import 'package:deliber/features/messaging/domain/entities/user_entity.dart';
import 'package:deliber/features/messaging/domain/repositories/message_repository.dart';
import 'package:fpdart/fpdart.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource messageRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  MessageRepositoryImpl(this.messageRemoteDataSource, this.authLocalDataSource);

  @override
  Future<Either<Failure, List<UserEntity>>> getUsers() async {
    try {
      final cachedUser = await authLocalDataSource.getCachedUser();
      if (cachedUser == null) {
        return const Left(UserFailure('No user logged in'));
      }

      final result = await messageRemoteDataSource.getUsers(cachedUser.token);
      return result.fold(
        (failure) => Left(failure),
        (users) => Right(users.map((user) => user.toEntity()).toList()),
      );
    } catch (e) {
      return Left(UserFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages({
    required String userId,
  }) async {
    try {
      final cachedUser = await authLocalDataSource.getCachedUser();
      if (cachedUser == null) {
        return const Left(MessageFailure('No user logged in'));
      }

      final result = await messageRemoteDataSource.getMessages(
        userId: userId,
        token: cachedUser.token,
      );

      return result.fold(
        (failure) => Left(failure),
        (messages) =>
            Right(messages.map((message) => message.toEntity()).toList()),
      );
    } catch (e) {
      return Left(MessageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String receiverId,
    required String message,
  }) async {
    try {
      final cachedUser = await authLocalDataSource.getCachedUser();
      if (cachedUser == null) {
        return const Left(MessageFailure('No user logged in'));
      }

      final result = await messageRemoteDataSource.sendMessage(
        receiverId: receiverId,
        message: message,
        token: cachedUser.token,
      );

      return result.fold(
        (failure) => Left(failure),
        (message) => Right(message.toEntity()),
      );
    } catch (e) {
      return Left(MessageFailure(e.toString()));
    }
  }
}
