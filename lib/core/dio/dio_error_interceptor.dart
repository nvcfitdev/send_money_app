import 'package:dio/dio.dart';
import 'package:maya_test_app/core/dio/api_exceptions.dart';

class DioErrorInterceptor extends Interceptor {
  DioErrorInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _errorToException(err);
    super.onError(exception, handler);
  }

  static ApiException _errorToException(DioException error) {
    final statusCode = error.response?.statusCode ?? 0;

    // Handle client errors (4xx)
    if (statusCode >= 400 && statusCode < 500) {
      return switch (statusCode) {
        400 => BadRequestException(error: error),
        401 => UnauthorizedException(error: error),
        403 => ForbiddenException(error: error),
        404 => NotFoundException(error: error),
        409 => ConflictException(error: error),
        _ => BadRequestException(error: error),
      };
    }

    // Handle server errors (5xx)
    if (statusCode >= 500 && statusCode < 600) {
      return ServerUnavailableException(error: error);
    }

    // Handle network and timeout errors
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return NetworkTimeoutException(error: error);
    }

    // Handle connection errors
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.unknown) {
      return NetworkTimeoutException(error: error);
    }

    // Handle all other errors
    return UnknownException(error: error);
  }
}
