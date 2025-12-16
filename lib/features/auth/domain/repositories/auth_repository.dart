import 'package:deliber/core/error/failure.dart';
import 'package:deliber/features/auth/domain/entity/user_entity.dart';

import 'package:fpdart/fpdart.dart';


abstract interface class AuthRepository {
  Future<Either<Failure,UserEntity?>> signInWIthGoogle();
  Future<Either<Failure,void>> logOut();
  Future<Either<Failure,UserEntity?>> getUser();
}
