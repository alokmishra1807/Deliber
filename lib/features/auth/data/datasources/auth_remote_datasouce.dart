import 'package:deliber/features/auth/data/model/user_model.dart';


abstract interface class AuthRemoteDataSource {
  Future<UserModel?> signInWithGoogle();
  Future<void> signOut();
  UserModel? getCurrentUser();
}
