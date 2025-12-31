import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/messaging/domain/entities/message_entity.dart';
import 'package:deliber/features/messaging/domain/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class MessageRepository {
  Future<Either<Failure, List<UserEntity>>> getUsers();

  Future<Either<Failure, List<MessageEntity>>> getMessages({
    required String userId,
  });

  Future<Either<Failure, MessageEntity>> sendMessage({
    required String receiverId,
    required String message,
  });
}
