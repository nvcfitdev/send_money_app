import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:maya_test_app/core/local/shared_preference_storage.dart';
import 'package:maya_test_app/presentation/wallet/data/api/wallet_api.dart';
import 'package:maya_test_app/presentation/wallet/data/contracts/transaction_api_contract.dart';
import 'package:maya_test_app/presentation/wallet/domain/entities/transaction.dart';
import 'package:maya_test_app/presentation/wallet/domain/repositories/wallet_repository.dart';
import 'package:maya_test_app/shared/constants/shared_prefs_keys.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'wallet_repository_test.mocks.dart';

@GenerateMocks([WalletApi, SharedPreferenceStorage])
void main() {
  late WalletRepository walletRepository;
  late MockWalletApi mockWalletApi;
  late MockSharedPreferenceStorage mockStorage;

  setUp(() async {
    mockWalletApi = MockWalletApi();
    mockStorage = MockSharedPreferenceStorage();
    walletRepository = WalletRepositoryImpl(mockWalletApi, mockStorage);
  });

  group('WalletRepository', () {
    test(
      'on getBalance returns initial balance when no balance is stored',
      () async {
        when(
          mockStorage.getValue<String>(SharedPrefsKeys.balance),
        ).thenAnswer((_) async => null);
        when(
          mockStorage.setValue(SharedPrefsKeys.balance, any),
        ).thenAnswer((_) async => true);

        final balance = await walletRepository.getBalance();

        expect(balance.amount, equals(50000));
        expect(balance.currency, equals('PHP'));
        verify(mockStorage.setValue(SharedPrefsKeys.balance, any)).called(1);
        verify(mockStorage.getValue<String>(SharedPrefsKeys.balance)).called(1);
      },
    );

    test('on getBalance returns stored balance', () async {
      final storedBalance = {'amount': 75000.0, 'currency': 'PHP'};

      when(
        mockStorage.getValue<String>(SharedPrefsKeys.balance),
      ).thenAnswer((_) async => json.encode(storedBalance));

      final balance = await walletRepository.getBalance();

      expect(balance.amount, equals(75000.0));
      expect(balance.currency, equals('PHP'));
    });

    test('on deductBalance throws error when insufficient balance', () async {
      final storedBalance = {'amount': 1000.0, 'currency': 'PHP'};

      when(
        mockStorage.getValue<String>(SharedPrefsKeys.balance),
      ).thenAnswer((_) async => json.encode(storedBalance));

      expect(
        () => walletRepository.deductBalance(2000.0),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Insufficient balance'),
          ),
        ),
      );
    });

    test('deductBalance updates balance correctly', () async {
      final storedBalance = {'amount': 2000.0, 'currency': 'PHP'};

      when(
        mockStorage.getValue<String>(SharedPrefsKeys.balance),
      ).thenAnswer((_) async => json.encode(storedBalance));

      when(
        mockStorage.setValue(SharedPrefsKeys.balance, any),
      ).thenAnswer((_) async => true);

      final balance = await walletRepository.deductBalance(500.0);

      expect(balance.amount, equals(1500.0));
      expect(balance.currency, equals('PHP'));
    });

    test('saveTransaction saves to local storage and API', () async {
      final transaction = Transaction(
        id: 'test_id',
        amount: 1000,
        date: DateTime.now(),
        status: 'Completed',
        description: 'Test transaction',
        source: TransactionSource.local,
      );

      when(
        mockStorage.getValue<String>(SharedPrefsKeys.transactions),
      ).thenAnswer((_) async => '[]');

      when(
        mockStorage.setValue(SharedPrefsKeys.transactions, any),
      ).thenAnswer((_) async => true);

      when(mockWalletApi.saveTransaction(any)).thenAnswer(
        (_) async => TransactionApiContract(
          id: transaction.id,
          amount: transaction.amount,
          date: transaction.date,
          status: transaction.status,
          description: transaction.description,
          source: transaction.source,
        ),
      );

      final savedTransaction = await walletRepository.saveTransaction(
        transaction,
      );

      verify(mockStorage.setValue(SharedPrefsKeys.transactions, any)).called(1);
      verify(mockWalletApi.saveTransaction(any)).called(1);

      expect(savedTransaction.id, equals(transaction.id));
      expect(savedTransaction.amount, equals(transaction.amount));
      expect(savedTransaction.status, equals(transaction.status));
      expect(savedTransaction.description, equals(transaction.description));
    });

    test('getTransactions combines local and API transactions', () async {
      final localTransactions = [
        Transaction(
          id: 'local_1',
          amount: 1000,
          date: DateTime.now(),
          status: 'Completed',
          description: 'Local transaction 1',
          source: TransactionSource.local,
        ),
      ];

      when(
        mockStorage.getValue<String>(SharedPrefsKeys.transactions),
      ).thenAnswer(
        (_) async =>
            json.encode(localTransactions.map((t) => t.toJson()).toList()),
      );

      when(mockWalletApi.getTransactions()).thenAnswer(
        (_) async => List.generate(
          5,
          (i) => TransactionApiContract(
            id: i.toString(),
            amount: 1000.0,
            date: DateTime.now().subtract(Duration(days: i)),
            status: 'Completed',
            description: 'API Transaction $i',
            source: TransactionSource.api,
          ),
        ),
      );

      final transactions = await walletRepository.getTransactions();

      verify(
        mockStorage.getValue<String>(SharedPrefsKeys.transactions),
      ).called(1);
      verify(mockWalletApi.getTransactions()).called(1);

      expect(transactions, isNotEmpty);
      expect(
        transactions.any((t) => t.source == TransactionSource.local),
        isTrue,
      );
      expect(
        transactions.any((t) => t.source == TransactionSource.api),
        isTrue,
      );
    });
  });
}
