import 'package:dio/dio.dart';

abstract class ApiException extends DioException {
  final String userMessage;

  ApiException({required DioException error, required this.userMessage})
    : super(
        requestOptions: error.requestOptions,
        response: error.response,
        error: error.error,
        type: error.type,
        stackTrace: error.stackTrace,
        message: error.message,
      );
}

class BadRequestException extends ApiException {
  BadRequestException({required super.error})
    : super(userMessage: 'The request was invalid. Please check your input.');
}

class ConflictException extends ApiException {
  ConflictException({required super.error})
    : super(userMessage: 'This operation conflicts with another request.');
}

class ForbiddenException extends ApiException {
  ForbiddenException({required super.error})
    : super(userMessage: 'You do not have permission to perform this action.');
}

class NetworkTimeoutException extends ApiException {
  NetworkTimeoutException({required super.error})
    : super(
        userMessage:
            'The request timed out. Please check your internet connection and try again.',
      );
}

class NotFoundException extends ApiException {
  NotFoundException({required super.error})
    : super(userMessage: 'The requested resource was not found.');
}

class ServerUnavailableException extends ApiException {
  ServerUnavailableException({required super.error})
    : super(
        userMessage:
            'The service is temporarily unavailable. Please try again later.',
      );
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({required super.error})
    : super(userMessage: 'Your session has expired. Please log in again.');
}

class UnknownException extends ApiException {
  UnknownException({required super.error})
    : super(userMessage: 'An unexpected error occurred. Please try again.');
}
