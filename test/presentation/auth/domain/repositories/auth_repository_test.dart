import 'package:flutter_test/flutter_test.dart';
import 'package:maya_test_app/core/local/shared_preference_storage.dart';
import 'package:maya_test_app/presentation/auth/data/api/auth_api.dart';
import 'package:maya_test_app/presentation/auth/domain/entities/auth.dart';
import 'package:maya_test_app/presentation/auth/domain/repositories/auth_repository.dart';
import 'package:maya_test_app/shared/constants/shared_prefs_keys.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([AuthApi, SharedPreferenceStorage])
void main() {
  late MockAuthApi mockAuthApi;
  late AuthRepository authRepository;
  late MockSharedPreferenceStorage mockStorage;

  setUp(() async {
    mockAuthApi = MockAuthApi();
    mockStorage = MockSharedPreferenceStorage();
    authRepository = AuthRepositoryImpl(mockAuthApi, mockStorage);
  });

  group('AuthRepository', () {
    test('on login success', () async {
      when(mockAuthApi.login()).thenAnswer(
        (_) async => Auth(
          username: 'testuser',
          isAuthenticated: true,
          message: 'Login successful',
        ),
      );

      final result = await authRepository.login();

      expect(result.username, equals('testuser'));
      expect(result.isAuthenticated, isTrue);
      expect(result.message, equals('Login successful'));
    });

    test('on login failure', () async {
      when(mockAuthApi.login()).thenThrow(Exception('Network error'));

      expect(
        () => authRepository.login(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Login failed'),
          ),
        ),
      );
    });

    test('on logout success', () async {
      when(mockAuthApi.logout()).thenAnswer((_) async => {});

      await expectLater(authRepository.logout(), completes);
    });

    test('on logout failure', () async {
      when(mockAuthApi.logout()).thenThrow(Exception('Network error'));

      expect(
        () => authRepository.logout(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Logout failed'),
          ),
        ),
      );
    });

    test('on mockErrorLogin success', () async {
      when(
        mockStorage.getValue<String>(SharedPrefsKeys.mockErrorLogin),
      ).thenAnswer((_) async => 'true');

      await expectLater(
        () => authRepository.login(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Login failed'),
          ),
        ),
      );
    });
  });
}
