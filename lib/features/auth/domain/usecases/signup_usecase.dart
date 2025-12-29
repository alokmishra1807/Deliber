import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/auth/domain/entity/user_entity.dart';
import 'package:deliber/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp {
  final AuthRepository authRepository;

  UserSignUp(this.authRepository);

  Future<Either<Failure, AuthEntity>> call({
    required String name,
    required String username,
    required String password,
    required String confirmedPassword,
    required String gender,
  }) {
    return authRepository.signUp(
      name: name,
      username: username,
      password: password,
      confirmedPassword: confirmedPassword,
      gender: gender,
    );
  }
}
