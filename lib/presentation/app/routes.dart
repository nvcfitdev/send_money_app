import 'package:flutter/material.dart';
import 'package:maya_test_app/presentation/auth/presentation/views/login_page.dart';
import 'package:maya_test_app/presentation/send_money/presentation/views/send_money_page.dart';
import 'package:maya_test_app/presentation/wallet/presentation/views/transaction_history_page.dart';
import 'package:maya_test_app/presentation/wallet/presentation/views/wallet_page.dart';

// Handle all the routes of the app..
class Routes {
  static const String login = '/login';
  static const String wallet = '/wallet';
  static const String sendMoney = '/send-money';
  static const String transactionHistory = '/transaction-history';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case wallet:
        return MaterialPageRoute(builder: (_) => const WalletPage());
      case sendMoney:
        return MaterialPageRoute(builder: (_) => const SendMoneyPage());
      case transactionHistory:
        return MaterialPageRoute(
          builder: (_) => const TransactionHistoryPage(),
        );
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }

  static void navigateToLogin(BuildContext context, {bool clearStack = false}) {
    if (clearStack) {
      Navigator.of(context).pushNamedAndRemoveUntil(login, (route) => false);
    } else {
      Navigator.of(context).pushNamed(login);
    }
  }

  static void navigateToSendMoney(BuildContext context) {
    Navigator.of(context).pushNamed(sendMoney);
  }

  static void navigateToTransactionHistory(BuildContext context) {
    Navigator.of(context).pushNamed(transactionHistory);
  }

  static void navigateToWallet(
    BuildContext context, {
    bool clearStack = false,
  }) {
    if (clearStack) {
      Navigator.of(context).pushNamedAndRemoveUntil(wallet, (route) => false);
    } else {
      Navigator.of(context).pushNamed(wallet);
    }
  }
}
