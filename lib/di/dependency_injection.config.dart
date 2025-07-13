// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:maya_test_app/core/dio/dio_provider.dart' as _i378;
import 'package:maya_test_app/core/local/shared_preference_storage.dart'
    as _i579;
import 'package:maya_test_app/di/app_config_module.dart' as _i799;
import 'package:maya_test_app/presentation/auth/data/api/auth_api.dart' as _i40;
import 'package:maya_test_app/presentation/auth/domain/repositories/auth_repository.dart'
    as _i989;
import 'package:maya_test_app/presentation/auth/presentation/cubits/auth_cubit.dart'
    as _i173;
import 'package:maya_test_app/presentation/send_money/data/api/send_money_api.dart'
    as _i958;
import 'package:maya_test_app/presentation/send_money/domain/repositories/send_money_repository.dart'
    as _i423;
import 'package:maya_test_app/presentation/send_money/presentation/cubits/send_money_cubit.dart'
    as _i361;
import 'package:maya_test_app/presentation/wallet/data/api/wallet_api.dart'
    as _i132;
import 'package:maya_test_app/presentation/wallet/domain/repositories/wallet_repository.dart'
    as _i281;
import 'package:maya_test_app/presentation/wallet/presentation/cubits/wallet_cubit.dart'
    as _i905;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appConfigModule = _$AppConfigModule();
    gh.factory<String>(() => appConfigModule.baseUrl, instanceName: 'baseUrl');
    gh.factory<_i378.BasicDioProvider>(() => _i378.BasicDioProviderImpl());
    gh.lazySingleton<_i579.SharedPreferenceStorage>(
      () => _i579.SharedPreferenceStorageImpl(),
    );
    gh.lazySingleton<_i40.AuthApi>(
      () => _i40.AuthApi(
        gh<_i378.BasicDioProvider>(),
        gh<String>(instanceName: 'baseUrl'),
      ),
    );
    gh.lazySingleton<_i958.SendMoneyApi>(
      () => _i958.SendMoneyApi(
        gh<_i378.BasicDioProvider>(),
        gh<String>(instanceName: 'baseUrl'),
      ),
    );
    gh.lazySingleton<_i132.WalletApi>(
      () => _i132.WalletApi(
        gh<_i378.BasicDioProvider>(),
        gh<String>(instanceName: 'baseUrl'),
      ),
    );
    gh.lazySingleton<_i281.WalletRepository>(
      () => _i281.WalletRepositoryImpl(
        gh<_i132.WalletApi>(),
        gh<_i579.SharedPreferenceStorage>(),
      ),
    );
    gh.factory<_i905.WalletCubit>(
      () => _i905.WalletCubit(gh<_i281.WalletRepository>()),
    );
    gh.lazySingleton<_i423.SendMoneyRepository>(
      () => _i423.SendMoneyRepositoryImpl(
        gh<_i958.SendMoneyApi>(),
        gh<_i281.WalletRepository>(),
      ),
    );
    gh.factory<_i361.SendMoneyCubit>(
      () => _i361.SendMoneyCubit(
        gh<_i423.SendMoneyRepository>(),
        gh<_i579.SharedPreferenceStorage>(),
      ),
    );
    gh.lazySingleton<_i989.AuthRepository>(
      () => _i989.AuthRepositoryImpl(gh<_i40.AuthApi>()),
    );
    gh.factory<_i173.AuthCubit>(
      () => _i173.AuthCubit(gh<_i989.AuthRepository>()),
    );
    return this;
  }
}

class _$AppConfigModule extends _i799.AppConfigModule {}
