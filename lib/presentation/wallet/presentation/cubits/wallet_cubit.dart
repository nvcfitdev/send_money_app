import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:maya_test_app/core/local/shared_preference_storage.dart';
import 'package:maya_test_app/presentation/auth/domain/repositories/auth_repository.dart';
import 'package:maya_test_app/presentation/wallet/domain/entities/transaction.dart';
import 'package:maya_test_app/shared/constants/shared_prefs_keys.dart';

import '../../domain/entities/balance.dart';
import '../../domain/repositories/wallet_repository.dart';

part '../models/wallet_state.dart';

@injectable
class WalletCubit extends Cubit<WalletState> {
  final WalletRepository _walletRepository;
  final AuthRepository _authRepository;
  final SharedPreferenceStorage _storage;

  WalletCubit(this._walletRepository, this._authRepository, this._storage)
    : super(WalletInitial());

  Future<void> deductBalance(double amount) async {
    if (state is WalletLoaded) {
      try {
        final newBalance = await _walletRepository.deductBalance(amount);
        final currentState = state as WalletLoaded;
        emit(
          WalletLoaded(
            balance: newBalance,
            transactions: currentState.transactions,
            isBalanceVisible: currentState.isBalanceVisible,
          ),
        );
      } catch (e) {
        emit(WalletError(message: e.toString()));
      }
    }
  }

  Future<void> getTransactions() async {
    if (state is! WalletLoaded) {
      emit(WalletLoading());
    }

    try {
      final transactions = await _walletRepository.getTransactions();
      if (state is WalletLoaded) {
        final currentState = state as WalletLoaded;
        emit(
          WalletLoaded(
            balance: currentState.balance,
            transactions: transactions,
            isBalanceVisible: currentState.isBalanceVisible,
          ),
        );
      } else {
        // If no current state, load both balance and transactions
        final balance = await _walletRepository.getBalance();
        emit(
          WalletLoaded(
            balance: balance,
            transactions: transactions,
            isBalanceVisible: true,
          ),
        );
      }
    } catch (e) {
      if (state is WalletLoaded) {
        // Keep the current state if there's an error loading transactions
        final currentState = state as WalletLoaded;
        emit(
          WalletLoaded(
            balance: currentState.balance,
            transactions: currentState.transactions,
            isBalanceVisible: currentState.isBalanceVisible,
          ),
        );
      } else {
        emit(WalletError(message: e.toString()));
      }
    }
  }

  Future<void> loadWalletData() async {
    emit(WalletLoading());

    try {
      final balance = await _walletRepository.getBalance();
      final transactions = await _walletRepository.getTransactions();

      emit(
        WalletLoaded(
          balance: balance,
          transactions: transactions,
          isBalanceVisible: true,
        ),
      );
    } catch (e) {
      emit(WalletError(message: e.toString()));
    }
  }

  Future<void> mockErrorLogout() async {
    final mockErrorLogout =
        await _storage.getValue<String>(SharedPrefsKeys.mockErrorLogout) ??
        'false';
    final newValue = mockErrorLogout == 'true' ? 'false' : 'true';
    await _storage.setValue(SharedPrefsKeys.mockErrorLogout, newValue);
    emit(WalletMockFailureToggled(newValue == 'true'));
  }

  Future<void> onLogout() async {
    emit(WalletLoading());
    try {
      await _authRepository.logout();
      emit(WalletLoggedOut());
    } catch (e) {
      emit(WalletError(message: e.toString()));
    }
  }

  Future<void> resetBalance() async {
    emit(WalletLoading());
    try {
      final balance = await _walletRepository.resetBalance();
      emit(WalletLoaded(balance: balance, isBalanceVisible: true));
    } catch (e) {
      emit(WalletError(message: e.toString()));
    }
  }

  void toggleBalanceVisibility() {
    if (state is WalletLoaded) {
      final currentState = state as WalletLoaded;
      emit(
        WalletLoaded(
          balance: currentState.balance,
          transactions: currentState.transactions,
          isBalanceVisible: !currentState.isBalanceVisible,
        ),
      );
    }
  }
}
