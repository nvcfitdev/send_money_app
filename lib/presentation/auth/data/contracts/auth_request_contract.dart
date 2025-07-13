import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/auth_request.dart';

part 'auth_request_contract.g.dart';

@JsonSerializable()
class AuthRequestContract extends AuthRequest {
  const AuthRequestContract({required super.username, required super.password});

  factory AuthRequestContract.fromJson(Map<String, dynamic> json) =>
      _$AuthRequestContractFromJson(json);

  // Convert to API request body
  Map<String, dynamic> toApiRequest() {
    return {
      'username': username,
      'password': password,
      'title': 'Authentication Request',
      'body': 'Login attempt for user: $username',
      'userId': 1,
    };
  }

  Map<String, dynamic> toJson() => _$AuthRequestContractToJson(this);
}
