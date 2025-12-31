import 'dart:convert';

import 'package:deliber/features/auth/domain/entity/user_entity.dart';

class AuthModel {
  final String id;
  final String username;
  final String fullName;
  final String gender;
  final String profilePic;
  final String token;

  AuthModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.gender,
    required this.profilePic,
    required this.token,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      username: (json['username'] ?? '').toString(),
      fullName: (json['fullName'] ?? '').toString(),
      gender: (json['gender'] ?? '').toString(),
      profilePic: (json['profilePic'] ?? json['profilepic'] ?? '').toString(),
      token: (json['token'] ?? '').toString(),
    );
  }

  AuthEntity toEntity() {
    return AuthEntity(
      id: id,
      username: username,
      fullName: fullName,
      gender: gender,
      profilePic: profilePic,
      token: token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'fullName': fullName,
      'gender': gender,
      'profilePic': profilePic,
      'token': token,
    };
  }

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      id: (map['_id'] ?? map['id'] ?? '').toString(),
      username: (map['username'] ?? '').toString(),
      fullName: (map['fullName'] ?? '').toString(),
      gender: (map['gender'] ?? '').toString(),
      profilePic: (map['profilePic'] ?? map['profilepic'] ?? '').toString(),
      token: (map['token'] ?? '').toString(),
    );
  }

  String toJson() => json.encode(toMap());
}
