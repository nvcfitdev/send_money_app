import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:maya_test_app/core/dio/dio_error_interceptor.dart';
import 'package:maya_test_app/core/dio/dio_logging_interceptor.dart';
import 'package:maya_test_app/di/app_config_module.dart';

abstract class BaseDioProvider {
  static const defaultTimeout = Duration(seconds: 30);

  final String baseUrl;
  final Duration timeout;

  BaseDioProvider({required this.baseUrl, this.timeout = defaultTimeout});

  Dio create<T>() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: timeout,
        sendTimeout: timeout,
        receiveTimeout: timeout,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    dio.interceptors.addAll([DioErrorInterceptor(), DioLoggingInterceptor()]);

    return dio;
  }
}

abstract interface class BasicDioProvider {
  Dio create<T>();
}

@Injectable(as: BasicDioProvider)
class BasicDioProviderImpl extends BaseDioProvider implements BasicDioProvider {
  BasicDioProviderImpl() : super(baseUrl: AppConfig.instance.baseUrl);
}
