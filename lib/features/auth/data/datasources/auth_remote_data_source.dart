import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/auth/data/model/auth_model.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRemoteDataSource {
  Future<Either<AuthFailure, AuthModel>> signUp({
    required String name,
    required String username,
    required String password,
    required String confirmedPassword,
    required String gender,
  });

   Future<Either<AuthFailure, AuthModel>> login({
    required String username,
    required String password,
  });
}
