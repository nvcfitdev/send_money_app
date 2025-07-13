import 'package:equatable/equatable.dart';

class Balance extends Equatable {
  final double amount;
  final String currency;

  const Balance({
    required this.amount,
    required this.currency,
  });

  @override
  List<Object> get props => [amount, currency];
} 