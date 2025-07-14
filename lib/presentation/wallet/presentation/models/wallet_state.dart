part of '../cubits/wallet_cubit.dart';

class WalletError extends WalletState {
  final String message;

  const WalletError({required this.message});

  @override
  List<Object> get props => [message];
}

class WalletInitial extends WalletState {}

class WalletLoaded extends WalletState {
  final Balance balance;
  final List<Transaction> transactions;
  final bool isBalanceVisible;

  const WalletLoaded({
    this.transactions = const [],
    this.balance = const Balance(amount: 0, currency: 'PHP'),
    this.isBalanceVisible = false,
  });

  @override
  List<Object> get props => [balance, transactions, isBalanceVisible];
}

class WalletLoading extends WalletState {}

class WalletLoggedOut extends WalletState {}

class WalletMockFailureToggled extends WalletState {
  final bool enabled;
  const WalletMockFailureToggled(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}
