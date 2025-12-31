import 'dart:convert';
import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/messaging/data/datasources/message_remote_datasource.dart';
import 'package:deliber/features/messaging/data/models/message_model.dart';
import 'package:deliber/features/messaging/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final http.Client client;

  MessageRemoteDataSourceImpl(this.client);

  @override
  Future<Either<Failure, List<UserModel>>> getUsers(String token) async {
    try {
      final response = await http.get(
        Uri.parse('https://message-app-backend-wjqq.onrender.com/api/user/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final resBody = jsonDecode(response.body);
        return Left(
          UserFailure((resBody['error'] ?? 'Failed to get users').toString()),
        );
      }

      final List<dynamic> resBody = jsonDecode(response.body);
      final users = resBody.map((user) => UserModel.fromMap(user)).toList();

      return Right(users);
    } catch (e) {
      return Left(UserFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageModel>>> getMessages({
    required String userId,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://message-app-backend-wjqq.onrender.com/api/message/$userId',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final resBody = jsonDecode(response.body);
        return Left(
          MessageFailure(
            (resBody['error'] ?? 'Failed to get messages').toString(),
          ),
        );
      }

      final List<dynamic> resBody = jsonDecode(response.body);
      final messages = resBody
          .map((message) => MessageModel.fromMap(message))
          .toList();

      return Right(messages);
    } catch (e) {
      return Left(MessageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageModel>> sendMessage({
    required String receiverId,
    required String message,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://message-app-backend-wjqq.onrender.com/api/message/send/$receiverId',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'message': message}),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        final resBody = jsonDecode(response.body);
        return Left(
          MessageFailure(
            (resBody['error'] ?? 'Failed to send message').toString(),
          ),
        );
      }

      final resBody = jsonDecode(response.body);
      return Right(MessageModel.fromMap(resBody));
    } catch (e) {
      return Left(MessageFailure(e.toString()));
    }
  }
}
