import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:maya_test_app/core/local/shared_preference_storage.dart';
import 'package:maya_test_app/shared/constants/shared_prefs_keys.dart';

import '../../domain/entities/auth.dart';
import '../../domain/repositories/auth_repository.dart';

part '../models/auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final SharedPreferenceStorage _storage;

  AuthCubit(this._authRepository, this._storage) : super(AuthInitial());

  Future<void> checkMockFailure() async {
    final mockError = await _storage.getValue<String>(
      SharedPrefsKeys.mockErrorLogin,
    );
    emit(AuthMockFailureToggled(mockError == 'true'));
  }

  Future<void> login(String username, String password) async {
    emit(AuthLoading());

    try {
      final auth = await _authRepository.login();
      if (auth.isAuthenticated) {
        emit(AuthAuthenticated(auth: auth));
      } else {
        emit(AuthError(message: auth.message ?? 'Authentication failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());

    try {
      await _authRepository.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> mockErrorLogin() async {
    final mockErrorLogin =
        await _storage.getValue<String>(SharedPrefsKeys.mockErrorLogin) ??
        'false';
    final newValue = mockErrorLogin == 'true' ? 'false' : 'true';
    await _storage.setValue(SharedPrefsKeys.mockErrorLogin, newValue);
    emit(AuthMockFailureToggled(newValue == 'true'));
  }

  void resetState() {
    emit(AuthInitial());
  }
}
