import 'package:equatable/equatable.dart';

class AuthRequest extends Equatable {
  final String username;
  final String password;

  const AuthRequest({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}
