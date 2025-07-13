import 'package:json_annotation/json_annotation.dart';

part 'token_contract.g.dart';

@JsonSerializable()
class TokenContract {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  const TokenContract({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  factory TokenContract.fromJson(Map<String, dynamic> json) =>
      _$TokenContractFromJson(json);

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toJson() => _$TokenContractToJson(this);
}
