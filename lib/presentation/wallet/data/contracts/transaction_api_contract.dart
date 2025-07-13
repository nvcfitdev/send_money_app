import '../../domain/entities/transaction.dart';

class TransactionApiContract extends Transaction {
  const TransactionApiContract({
    required super.id,
    required super.amount,
    required super.date,
    required super.source,
    required super.status,
    required super.description,
  });

  factory TransactionApiContract.fromJson(Map<String, dynamic> json) {
    return TransactionApiContract(
      id: json['id'] != null ? json['id'].toString() : 'unknown',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      source: _parseTransactionSource(json['source']),
      status: json['status'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  @override
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

  static TransactionSource _parseTransactionSource(dynamic source) {
    if (source == null) return TransactionSource.local;

    final sourceString = source.toString().toLowerCase();
    if (sourceString.contains('api')) {
      return TransactionSource.api;
    } else if (sourceString.contains('local')) {
      return TransactionSource.local;
    }
    return TransactionSource.local;
  }
}
