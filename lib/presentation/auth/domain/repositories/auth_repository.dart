import 'dart:async';

import 'package:injectable/injectable.dart';

import '../../../../core/local/shared_preference_storage.dart';
import '../../../../shared/constants/shared_prefs_keys.dart';
import '../../data/api/auth_api.dart';
import '../entities/auth.dart';

abstract interface class AuthRepository {
  Future<Auth> login();

  Future<void> logout();
}

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _authApi;
  final SharedPreferenceStorage _storage;

  AuthRepositoryImpl(this._authApi, this._storage);

  @override
  Future<Auth> login() async {
    try {
      // Mock login error
      final mockErrorLogin =
          await _storage.getValue<String>(SharedPrefsKeys.mockErrorLogin) ??
          'false';

      if (mockErrorLogin == 'true') {
        throw Exception('Simulated login error');
      }

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
      // Mock logout error
      final mockErrorLogout =
          await _storage.getValue<String>(SharedPrefsKeys.mockErrorLogout) ??
          'false';

      if (mockErrorLogout == 'true') {
        throw Exception('Simulated logout error');
      }

      await _authApi.logout();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}
