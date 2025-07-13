import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/dio/dio_provider.dart';
import '../../../wallet/data/contracts/transaction_api_contract.dart';

part 'send_money_api.g.dart';

@RestApi()
@lazySingleton
abstract class SendMoneyApi {
  @factoryMethod
  factory SendMoneyApi(
    BasicDioProvider dioProvider,
    @Named('baseUrl') String baseUrl,
  ) => _SendMoneyApi(dioProvider.create<SendMoneyApi>(), baseUrl: baseUrl);

  @POST('/posts')
  Future<TransactionApiContract> sendMoney(
    @Body() Map<String, dynamic> transaction,
  );
}
