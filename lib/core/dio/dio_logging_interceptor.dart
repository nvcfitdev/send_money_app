import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:maya_test_app/core/logging/log_level.dart';
import 'package:maya_test_app/core/logging/log_object.dart';

class DioLoggingInterceptor extends Interceptor {
  DioLoggingInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final logObject = LogObject(
      level: LogLevel.error,
      message:
          'HTTP Error: ${err.type}\n'
          'Path: ${err.requestOptions.path}\n'
          'Status Code: ${err.response?.statusCode}\n'
          'Error: ${err.error}\n'
          'Data: ${err.response?.data}',
      owner: 'DioLoggingInterceptor',
      error: err,
      stackTrace: err.stackTrace,
    );

    developer.log(
      logObject.formattedMessage,
      time: DateTime.now(),
      name: logObject.owner,
      level: logObject.level.value,
      error: err,
      stackTrace: err.stackTrace,
    );

    super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final logObject = LogObject(
      level: LogLevel.info,
      message:
          'HTTP Request: ${options.method} ${options.path}\n'
          'Headers: ${options.headers}\n'
          'Query Parameters: ${options.queryParameters}\n'
          'Data: ${options.data}',
      owner: 'DioLoggingInterceptor',
    );

    developer.log(
      logObject.formattedMessage,
      time: DateTime.now(),
      name: logObject.owner,
      level: logObject.level.value,
    );

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final logObject = LogObject(
      level: LogLevel.info,
      message:
          'HTTP Response: ${response.statusCode}\n'
          'Path: ${response.requestOptions.path}\n'
          'Headers: ${response.headers.map}\n'
          'Data: ${response.data}',
      owner: 'DioLoggingInterceptor',
    );

    developer.log(
      logObject.formattedMessage,
      time: DateTime.now(),
      name: logObject.owner,
      level: logObject.level.value,
    );

    super.onResponse(response, handler);
  }
}
