import 'package:deliber/features/auth/domain/entity/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
  });

  factory UserModel.fromFirebase(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: uid,
      email: email,
      name: displayName,
      avatar: photoUrl,
    );
  }
}
