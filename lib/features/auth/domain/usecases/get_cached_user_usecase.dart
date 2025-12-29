import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/auth/domain/entity/user_entity.dart';
import 'package:deliber/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetCachedUserUseCase {
  final AuthRepository repository;

  GetCachedUserUseCase(this.repository);

  Future<Either<Failure, AuthEntity>> call() {
    return repository.getCachedUser();
  }
}
