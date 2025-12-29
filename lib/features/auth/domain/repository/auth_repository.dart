import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/auth/domain/entity/user_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, AuthEntity>> signUp({
    required String name,
    required String username,
    required String password,
    required String confirmedPassword,
    required String gender,
  });
  Future<Either<Failure, AuthEntity>> loginWithUsernamePassword({
    required String username,
    required String password,
  });
  Future<Either<Failure, AuthEntity>> getCachedUser();
}
