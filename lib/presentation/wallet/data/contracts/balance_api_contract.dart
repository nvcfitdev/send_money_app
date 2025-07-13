import '../../domain/entities/balance.dart';

class BalanceApiContract extends Balance {
  const BalanceApiContract({required super.amount, required super.currency});

  factory BalanceApiContract.fromJson(Map<String, dynamic> json) {
    return BalanceApiContract(
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
    );
  }

  factory BalanceApiContract.fromPosts(List<dynamic> posts) {
    double totalAmount = 0;
    for (var post in posts) {
      totalAmount += (post['amount'] as num).toDouble();
    }
    return BalanceApiContract(amount: totalAmount, currency: 'PHP');
  }
}
