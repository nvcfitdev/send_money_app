// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserContract _$UserContractFromJson(Map<String, dynamic> json) => UserContract(
  username: json['username'] as String,
  isAuthenticated: json['isAuthenticated'] as bool,
);

Map<String, dynamic> _$UserContractToJson(UserContract instance) =>
    <String, dynamic>{
      'username': instance.username,
      'isAuthenticated': instance.isAuthenticated,
    };
