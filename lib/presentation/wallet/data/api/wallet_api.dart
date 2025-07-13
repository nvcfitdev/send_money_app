import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:maya_test_app/presentation/wallet/data/contracts/balance_api_contract.dart';
import 'package:maya_test_app/presentation/wallet/data/contracts/transaction_api_contract.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/dio/dio_provider.dart';

part 'wallet_api.g.dart';

@lazySingleton
@RestApi()
abstract interface class WalletApi {
  @factoryMethod
  factory WalletApi(
    BasicDioProvider dioProvider,
    @Named('baseUrl') String baseUrl,
  ) => _WalletApi(dioProvider.create<WalletApi>(), baseUrl: baseUrl);

  @GET('/posts')
  Future<BalanceApiContract> getBalance();

  @GET('/posts')
  Future<List<TransactionApiContract>> getTransactions();

  @POST('/posts')
  Future<TransactionApiContract> saveTransaction(
    @Body() Map<String, dynamic> transaction,
  );
}
