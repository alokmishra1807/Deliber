import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/auth/domain/repositories/auth_repository.dart';

import 'package:fpdart/fpdart.dart';

class LogoutUsecase {
  final AuthRepository authRepository;

  LogoutUsecase(this.authRepository);

   Future<Either<Failure,void>> call() {
    return authRepository.logOut();
  }
}
