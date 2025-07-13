import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/dio/dio_provider.dart';
import '../../domain/entities/auth.dart';

part 'auth_api.g.dart';

@RestApi()
@lazySingleton
abstract class AuthApi {
  @factoryMethod
  factory AuthApi(
    BasicDioProvider dioProvider,
    @Named('baseUrl') String baseUrl,
  ) => _AuthApi(dioProvider.create<AuthApi>(), baseUrl: baseUrl);

  // Use GET /users/1 as a simulate login endpoint
  @GET('/users/1')
  Future<Auth> login();

  // Use POST /users/1 to simulate logout endpoint
  @POST('/users/1')
  Future<void> logout();
}
