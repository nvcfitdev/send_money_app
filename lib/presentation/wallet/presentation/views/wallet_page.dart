import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:maya_test_app/presentation/app/routes.dart';

import '../cubits/wallet_cubit.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  bool _mockFailureEnabled = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<WalletCubit>()..loadWalletData(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome!'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => context.read<WalletCubit>().onLogout(),
            ),
          ],
        ),
        body: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state) {
            if (state is WalletMockFailureToggled) {
              _mockFailureEnabled = state.enabled;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.read<WalletCubit>().loadWalletData();
              });
            } else if (state is WalletLoggedOut) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Routes.navigateToLogin(context, clearStack: true);
              });
            }

            if (state is WalletLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is WalletError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.message}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          () => context.read<WalletCubit>().loadWalletData(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is WalletLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Balance',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    state.isBalanceVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<WalletCubit>()
                                        .toggleBalanceVisibility();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.isBalanceVisible
                                  ? NumberFormat.currency(
                                    symbol: state.balance.currency,
                                  ).format(state.balance.amount)
                                  : '${state.balance.currency} ****',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed:
                                () => Routes.navigateToSendMoney(context),
                            icon: const Icon(Icons.send),
                            label: const Text('Send Money'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed:
                                () => Routes.navigateToTransactionHistory(
                                  context,
                                ),
                            icon: const Icon(Icons.history),
                            label: const Text('View Transactions'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Reset Balance'),
                                content: const Text(
                                  'Are you sure you want to reset your balance to PHP 50,000.00?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context
                                          .read<WalletCubit>()
                                          .resetBalance();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Reset'),
                                  ),
                                ],
                              ),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset Balance'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Theme.of(context).colorScheme.onError,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _mockFailureEnabled ? Colors.green : Colors.red,
                      ),
                      onPressed:
                          () => context.read<WalletCubit>().mockErrorLogout(),
                      child: Text(
                        _mockFailureEnabled
                            ? 'Disable Mock Error Login'
                            : 'Enable Mock Error Login',
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
