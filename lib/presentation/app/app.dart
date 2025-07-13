import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maya_test_app/di/dependency_injection.dart';
import 'package:maya_test_app/presentation/app/routes.dart';
import 'package:maya_test_app/presentation/app/theme.dart';
import 'package:maya_test_app/presentation/auth/presentation/cubits/auth_cubit.dart';
import 'package:maya_test_app/presentation/send_money/presentation/cubits/send_money_cubit.dart';
import 'package:maya_test_app/presentation/wallet/presentation/cubits/wallet_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthCubit>()),
        BlocProvider(create: (context) => getIt<WalletCubit>()),
        BlocProvider(create: (context) => getIt<SendMoneyCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        onGenerateRoute: Routes.generateRoute,
        initialRoute: Routes.login,
      ),
    );
  }
}
