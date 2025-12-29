import 'dart:convert';

import 'package:deliber/features/auth/data/model/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(AuthModel authModel);
  Future<AuthModel?> getCachedUser();
  Future<void> clearCache();
  Future<String?> getToken();
  Future<void> cacheToken(String token);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String _userKey = 'cached_user';
  static const String _tokenKey = 'auth_token';

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheUser(AuthModel authModel) async {
    final userJson = jsonEncode(authModel.toMap());
    await sharedPreferences.setString(_userKey, userJson);

    // Also cache the token
    if (authModel.token.isNotEmpty) {
      await sharedPreferences.setString(_tokenKey, authModel.token);
    }
  }

  @override
  Future<AuthModel?> getCachedUser() async {
    final userJson = sharedPreferences.getString(_userKey);
    if (userJson == null) return null;

    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return AuthModel.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(_userKey);
    await sharedPreferences.remove(_tokenKey);
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(_tokenKey);
  }

  @override
  Future<void> cacheToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }
}
