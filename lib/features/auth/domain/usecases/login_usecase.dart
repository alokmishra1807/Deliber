import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/auth/domain/entity/user_entity.dart';
import 'package:deliber/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogin {
  final AuthRepository authRepository;

  UserLogin(this.authRepository);

  Future<Either<Failure, AuthEntity>> call({
    required String username,
    required String password,
  }) {
    return authRepository.loginWithUsernamePassword(
      username: username,
      password: password,
    );
  }
}
