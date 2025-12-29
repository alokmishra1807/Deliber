import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:deliber/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:deliber/features/auth/domain/entity/user_entity.dart';
import 'package:deliber/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, AuthEntity>> signUp({
    required String name,
    required String username,
    required String password,
    required String confirmedPassword,
    required String gender,
  }) async {
    try {
      final result = await remoteDataSource.signUp(
        name: name,
        username: username,
        password: password,
        confirmedPassword: confirmedPassword,
        gender: gender,
      );

      final authModelOpt = result.getRight();
      final authModel = authModelOpt.toNullable();

      if (authModel == null) {
        final failure =
            result.getLeft().toNullable() ??
            const AuthFailure('Unexpected signup failure');
        return Left(failure);
      }

      await localDataSource.cacheUser(authModel);
      return Right(authModel.toEntity());
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> loginWithUsernamePassword({
    required String username,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.login(
        username: username,
        password: password,
      );

      final authModelOpt = result.getRight();
      final authModel = authModelOpt.toNullable();

      if (authModel == null) {
        final failure =
            result.getLeft().toNullable() ??
            const AuthFailure('Unexpected login failure');
        return Left(failure);
      }

      await localDataSource.cacheUser(authModel);
      return Right(authModel.toEntity());
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getCachedUser() async {
    try {
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser.toEntity());
      }
      return Left(AuthFailure('No cached user found'));
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
