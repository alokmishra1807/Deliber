import 'package:deliber/features/messaging/domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String username;
  final String fullName;
  final String gender;
  final String profilePic;

  UserModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.gender,
    required this.profilePic,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: (map['_id'] ?? map['id'] ?? '').toString(),
      username: (map['username'] ?? '').toString(),
      fullName: (map['fullName'] ?? '').toString(),
      gender: (map['gender'] ?? '').toString(),
      profilePic: (map['profilePic'] ?? map['profilepic'] ?? '').toString(),
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: username,
      fullName: fullName,
      gender: gender,
      profilePic: profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'gender': gender,
      'profilePic': profilePic,
    };
  }
}
