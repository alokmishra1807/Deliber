import 'dart:convert';
import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:deliber/features/auth/data/model/auth_model.dart';
import 'package:fpdart/fpdart.dart';

import 'package:http/http.dart' as http;

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<Either<AuthFailure, AuthModel>> signUp({
    required String name,
    required String username,
    required String password,
    required String confirmedPassword,
    required String gender,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://message-app-backend-wjqq.onrender.com/api/auth/signup',
        ),
        headers: {'Content-Type': 'application/json'},

        body: jsonEncode({
          'fullName': name,
          'username': username,
          'password': password,
          'confirmedPassword': confirmedPassword,
          'gender': gender,
        }),
      );
      final resBody = jsonDecode(response.body);
      final resBodyMap = (resBody is Map<String, dynamic>)
          ? resBody
          : <String, dynamic>{};
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return Left(
          AuthFailure((resBodyMap['error'] ?? 'Signup failed').toString()),
        );
      }

      // Backend may wrap data
      final data = (resBodyMap['data'] is Map<String, dynamic>)
          ? resBodyMap['data'] as Map<String, dynamic>
          : resBodyMap;

      return Right(AuthModel.fromMap(data));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, AuthModel>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://message-app-backend-wjqq.onrender.com/api/auth/login',
        ),
        headers: {'Content-Type': 'application/json'},

        body: jsonEncode({'username': username, 'password': password}),
      );
      final resBody = jsonDecode(response.body);
      final resBodyMap = (resBody is Map<String, dynamic>)
          ? resBody
          : <String, dynamic>{};
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return Left(
          AuthFailure((resBodyMap['error'] ?? 'Login failed').toString()),
        );
      }

      final data = (resBodyMap['data'] is Map<String, dynamic>)
          ? resBodyMap['data'] as Map<String, dynamic>
          : resBodyMap;

      return Right(AuthModel.fromMap(data));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
