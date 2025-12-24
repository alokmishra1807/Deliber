import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/auth/data/datasources/auth_remote_datasouce.dart';

import 'package:deliber/features/auth/domain/entity/user_entity.dart';
import 'package:deliber/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImp implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImp(this.authRemoteDataSource);

  @override
  Future<Either<Failure, UserEntity?>> signInWIthGoogle() async {
    try {
      final userModel = await authRemoteDataSource.signInWithGoogle();
       if (userModel == null) {
      return const Right<Failure, UserEntity?>(null);
    }
      

      final userEntity = userModel.toEntity();

      return Right(userEntity);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logOut() async {
    try {
      await authRemoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure('Logout failed'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getUser() async{
    try {
      final userModel =authRemoteDataSource.getCurrentUser();
       if (userModel == null) {
      return const Right<Failure, UserEntity?>(null);
    }

      final userEntity = userModel.toEntity();

      return Right(userEntity);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
