import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../data/api/auth_api.dart';
import '../entities/auth.dart';

abstract interface class AuthRepository {
  Future<Auth> login();

  Future<void> logout();
}

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _authApi;

  AuthRepositoryImpl(this._authApi);

  @override
  Future<Auth> login() async {
    try {
      final response = await _authApi.login();
      final auth = Auth(
        username: response.username,
        isAuthenticated: true,
        message: response.message,
      );
      return auth;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _authApi.logout();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}
