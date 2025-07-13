import 'package:json_annotation/json_annotation.dart';

import 'token_contract.dart';
import 'user_contract.dart';

part 'auth_response_contract.g.dart';

@JsonSerializable()
class AuthResponseContract {
  final UserContract user;
  final TokenContract token;
  final String message;
  final bool success;

  const AuthResponseContract({
    required this.user,
    required this.token,
    this.message = '',
    this.success = true,
  });

  factory AuthResponseContract.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseContractFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseContractToJson(this);
}
