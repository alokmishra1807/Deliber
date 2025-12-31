import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/messaging/data/models/message_model.dart';
import 'package:deliber/features/messaging/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';

abstract class MessageRemoteDataSource {
  Future<Either<Failure, List<UserModel>>> getUsers(String token);

  Future<Either<Failure, List<MessageModel>>> getMessages({
    required String userId,
    required String token,
  });

  Future<Either<Failure, MessageModel>> sendMessage({
    required String receiverId,
    required String message,
    required String token,
  });
}
