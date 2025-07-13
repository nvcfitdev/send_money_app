import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:maya_test_app/core/local/shared_preference_storage.dart';
import 'package:maya_test_app/presentation/wallet/data/contracts/transaction_api_contract.dart';

import '../../../../shared/constants/shared_prefs_keys.dart';
import '../../data/api/wallet_api.dart';
import '../entities/balance.dart';
import '../entities/transaction.dart';

abstract interface class WalletRepository {
  Future<Balance> deductBalance(double amount);
  Future<Balance> getBalance();
  Future<List<Transaction>> getTransactions();
  Future<Balance> resetBalance();
  Future<Transaction> saveTransaction(Transaction transaction);
}

@LazySingleton(as: WalletRepository)
class WalletRepositoryImpl implements WalletRepository {
  final WalletApi _walletApi;
  final SharedPreferenceStorage _storage;

  WalletRepositoryImpl(this._walletApi, this._storage);

  @override
  Future<Balance> deductBalance(double amount) async {
    try {
      final currentBalance = await getBalance();
      if (currentBalance.amount < amount) {
        throw Exception('Insufficient balance');
      }
      final newBalance = Balance(
        amount: currentBalance.amount - amount,
        currency: currentBalance.currency,
      );
      await _saveBalance(newBalance);
      return newBalance;
    } catch (e) {
      throw Exception('Failed to deduct balance: $e');
    }
  }

  @override
  Future<Balance> getBalance() async {
    try {
      final balanceJson = await _storage.getValue<String>(
        SharedPrefsKeys.balance,
      );
      if (balanceJson == null) {
        return Balance(amount: 50000, currency: 'PHP');
      }
      final Map<String, dynamic> data = json.decode(balanceJson);
      return Balance(
        amount: data['amount'] as double,
        currency: data['currency'] as String,
      );
    } catch (e) {
      throw Exception('Failed to fetch balance: $e');
    }
  }

  @override
  Future<List<Transaction>> getTransactions() async {
    try {
      // Get cached local transactions
      final localTransactions = await _getCachedTransactions();

      // Get API transactions
      final apiTransactions = await _getApiTransactions();

      // Combine and sort all transactions by date
      final allTransactions = [...localTransactions, ...apiTransactions]
        ..sort((a, b) => b.date.compareTo(a.date));

      return allTransactions;
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  @override
  Future<Balance> resetBalance() async {
    try {
      final balance = Balance(amount: 50000, currency: 'PHP');
      await _saveBalance(balance);
      return balance;
    } catch (e) {
      throw Exception('Failed to reset balance: $e');
    }
  }

  @override
  Future<Transaction> saveTransaction(Transaction transaction) async {
    try {
      // Create a local transaction copy
      final localTransaction = Transaction(
        id: transaction.id,
        amount: transaction.amount,
        date: transaction.date,
        status: transaction.status,
        description: transaction.description,
        source: TransactionSource.local,
      );

      // Save to local cache first
      final currentTransactions = await _getCachedTransactions();
      final updatedTransactions = [localTransaction, ...currentTransactions];
      await _cacheTransactions(updatedTransactions);

      return localTransaction;
    } catch (e) {
      throw Exception('Failed to save transaction: $e');
    }
  }

  Future<void> _cacheTransactions(List<Transaction> transactions) async {
    try {
      final jsonString = json.encode(
        transactions.map((t) => t.toJson()).toList(),
      );
      await _storage.setValue(SharedPrefsKeys.transactions, jsonString);
    } catch (e) {
      print('Failed to cache transactions: $e');
    }
  }

  Future<List<Transaction>> _getApiTransactions() async {
    try {
      final apiTransactions = await _walletApi.getTransactions();

      // Take first 10 transactions from API and modify them to make it look like a real transaction lol..
      final transactions =
          apiTransactions.take(10).map((t) {
            final idInt =
                t.id is int ? t.id as int : int.tryParse(t.id.toString()) ?? 0;
            final random = DateTime.now().millisecondsSinceEpoch + idInt * 1000;
            final randomAmount = 1000 + (random % 9000) + (random % 555);

            final transactionDate = DateTime.now().subtract(
              Duration(days: idInt),
            );
            final uniqueId =
                'TXN${DateTime.now().millisecondsSinceEpoch}$idInt';

            return TransactionApiContract(
              id: uniqueId,
              amount: randomAmount.toDouble(),
              date: transactionDate,
              status: 'Completed',
              description: 'API Transaction $idInt',
              source: TransactionSource.api,
            );
          }).toList();

      return transactions;
    } catch (e) {
      print('Error fetching API transactions: $e');
      return [];
    }
  }

  Future<List<Transaction>> _getCachedTransactions() async {
    try {
      final jsonString = await _storage.getValue<String>(
        SharedPrefsKeys.transactions,
      );
      if (jsonString == null) return [];

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Transaction.fromJson(json)).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    } catch (e) {
      print('Error reading cached transactions: $e');
      return [];
    }
  }

  Future<void> _saveBalance(Balance balance) async {
    final balanceJson = json.encode({
      'amount': balance.amount,
      'currency': balance.currency,
    });
    await _storage.setValue(SharedPrefsKeys.balance, balanceJson);
  }
}
