import 'package:deliber/features/auth/data/datasources/auth_remote_datasouce.dart';
import 'package:deliber/features/auth/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  AuthRemoteDatasourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  @override
  Future<UserModel?> signInWithGoogle() async {
    await GoogleSignIn.instance.initialize(
      serverClientId:
          '662854403928-kk5euo2norpja705t7f94lfpphbqqvja.apps.googleusercontent.com',
    );

    final account = await GoogleSignIn.instance.authenticate();

    final auth = account.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: auth.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    final firebaseUser = userCredential.user;

    if (firebaseUser == null) {
      throw Exception('Firebase user is null');
    }

    
    return UserModel.fromFirebase(firebaseUser);
  }

  @override
  Future<void> signOut() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
  }

  @override
  UserModel? getCurrentUser() {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;
    return UserModel.fromFirebase(user);
  }
}
