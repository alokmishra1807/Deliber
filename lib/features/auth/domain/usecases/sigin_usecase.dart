import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/auth/domain/entity/user_entity.dart';
import 'package:deliber/features/auth/domain/repositories/auth_repository.dart';

import 'package:fpdart/fpdart.dart';

class SignInUsecase {
  final AuthRepository authRepository;

  SignInUsecase(this.authRepository);

   Future<Either<Failure,UserEntity?>> call() {
    return authRepository.signInWIthGoogle();
  }
}
