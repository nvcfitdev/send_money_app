import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user.dart';

part 'user_contract.g.dart';

@JsonSerializable()
class UserContract extends User {
  const UserContract({required super.username, required super.isAuthenticated});

  factory UserContract.fromJson(Map<String, dynamic> json) =>
      _$UserContractFromJson(json);

  Map<String, dynamic> toJson() => _$UserContractToJson(this);
}
