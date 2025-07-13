import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String username;
  final bool isAuthenticated;

  const User({required this.username, required this.isAuthenticated});

  @override
  List<Object> get props => [username, isAuthenticated];
}
