part of '../cubits/auth_cubit.dart';

class AuthAuthenticated extends AuthState {
  final Auth auth;

  const AuthAuthenticated({required this.auth});

  @override
  List<Object> get props => [auth];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthMockFailureToggled extends AuthState {
  final bool enabled;
  const AuthMockFailureToggled(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}
