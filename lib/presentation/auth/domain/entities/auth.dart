import 'package:equatable/equatable.dart';

class Auth extends Equatable {
  final String username;
  final bool isAuthenticated;
  final String? message;

  const Auth({
    required this.username,
    this.isAuthenticated = false,
    this.message,
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      username: json['username'] as String,
      isAuthenticated: json['isAuthenticated'] as bool? ?? false,
      message: json['message'] as String?,
    );
  }

  factory Auth.unauthenticated() {
    return const Auth(username: '', isAuthenticated: false);
  }

  @override
  List<Object?> get props => [username, isAuthenticated, message];

  Auth copyWith({String? username, bool? isAuthenticated, String? message}) {
    return Auth(
      username: username ?? this.username,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'isAuthenticated': isAuthenticated,
      'message': message,
    };
  }
}
