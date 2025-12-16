import 'package:deliber/features/auth/data/model/user_model.dart';


abstract class AuthRemoteDataSource {
  Future<UserModel?> signInWithGoogle();
  Future<void> signOut();
  UserModel? getCurrentUser();
}
