import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final double amount;
  final DateTime date;
  final String status;
  final String description;
  final TransactionSource source;

  const Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.status,
    required this.description,
    this.source = TransactionSource.local,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      amount: json['amount'] as double,
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
      description: json['description'] as String,
      source:
          json['source'] != null
              ? TransactionSource.values.firstWhere(
                (e) => e.toString() == json['source'],
                orElse: () => TransactionSource.local,
              )
              : TransactionSource.local,
    );
  }

  @override
  List<Object> get props => [id, amount, date, status, description, source];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'status': status,
      'description': description,
      'source': source.toString(),
    };
  }
}

enum TransactionSource { api, local }
