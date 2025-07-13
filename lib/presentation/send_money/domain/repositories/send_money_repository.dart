import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:maya_test_app/presentation/wallet/domain/repositories/wallet_repository.dart';

import '../../../wallet/domain/entities/transaction.dart';
import '../../data/api/send_money_api.dart';

abstract interface class SendMoneyRepository {
  Future<Transaction> sendMoney(double amount);
}

@LazySingleton(as: SendMoneyRepository)
class SendMoneyRepositoryImpl implements SendMoneyRepository {
  final SendMoneyApi _sendMoneyApi;
  final WalletRepository _walletRepository;

  SendMoneyRepositoryImpl(this._sendMoneyApi, this._walletRepository);

  @override
  Future<Transaction> sendMoney(double amount) async {
    if (amount <= 0) {
      throw Exception('Amount must be greater than zero');
    }

    if (amount > 10000) {
      throw Exception('Amount cannot exceed PHP 10,000');
    }

    // First deduct the balance from wallet..
    await _walletRepository.deductBalance(amount);

    // Generate a unique transaction ID for bottomsheet..
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final uniqueId = 'TXN$timestamp';

    final transaction = Transaction(
      id: uniqueId,
      amount: amount,
      date: DateTime.now(),
      status: 'Completed',
      description: 'Send Money Transaction',
      source: TransactionSource.local,
    );

    // Mock the API call to save the transaction..
    try {
      await _sendMoneyApi.sendMoney({
        'id': uniqueId,
        'amount': amount,
        'title': 'Send Money Transaction',
        'body': 'Transaction details',
        'userId': 1,
      });
    } catch (e) {
      print('Failed to save to API: $e');
    }

    // Save the transaction locally for display under Local Transactions..
    await _walletRepository.saveTransaction(transaction);

    return transaction;
  }
}
