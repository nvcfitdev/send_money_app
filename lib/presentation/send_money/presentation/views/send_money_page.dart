import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:maya_test_app/presentation/app/routes.dart';

import '../../../wallet/domain/entities/transaction.dart';
import '../cubits/send_money_cubit.dart';

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({super.key});

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _mockFailureEnabled = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<SendMoneyCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Send Money')),
        body: BlocBuilder<SendMoneyCubit, SendMoneyState>(
          builder: (context, state) {
            if (state is SendMoneySuccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showSuccessBottomSheet(context, state.transaction);
              });
            } else if (state is SendMoneyError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showErrorBottomSheet(context, state.message);
              });
            } else if (state is SendMoneyMockFailureToggled) {
              _mockFailureEnabled = state.enabled;
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter Amount',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}$'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Amount (PHP)',
                        hintText: '0.00',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }

                        final amount = double.tryParse(value);
                        if (amount == null) {
                          return 'Please enter a valid amount';
                        }

                        if (amount <= 0) {
                          return 'Amount must be greater than zero';
                        }

                        if (amount > 10000) {
                          return 'Amount cannot exceed PHP 10,000';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed:
                          state is SendMoneyLoading
                              ? null
                              : () {
                                if (_formKey.currentState!.validate()) {
                                  final amount = double.parse(
                                    _amountController.text,
                                  );
                                  context.read<SendMoneyCubit>().sendMoney(
                                    amount,
                                  );
                                }
                              },
                      child:
                          state is SendMoneyLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Send Money'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _mockFailureEnabled ? Colors.green : Colors.red,
                      ),
                      onPressed: () {
                        if (_mockFailureEnabled) {
                          context.read<SendMoneyCubit>().disableMockFailure();
                        } else {
                          context.read<SendMoneyCubit>().simulateFailure();
                        }
                      },
                      child: Text(
                        _mockFailureEnabled
                            ? 'Disable Mock Failure'
                            : 'Enable Mock Failure',
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check mock failure state when dependencies change (e.g., after navigation)
    context.read<SendMoneyCubit>().checkMockFailure();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _formKey.currentState?.reset();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Check mock failure state on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SendMoneyCubit>().checkMockFailure();
    });
  }

  void _showErrorBottomSheet(BuildContext context, String message) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/lottie/ic_failed_icon.json',
                  width: 240,
                  height: 240,
                  repeat: false,
                ),
                const SizedBox(height: 16),
                Text(
                  'Naku naku naku mamser',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessBottomSheet(BuildContext context, Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/lottie/ic_success_icon.json',
                  width: 240,
                  height: 240,
                  repeat: false,
                ),
                Text(
                  'Maraming Salamat, po!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'You have sent ${NumberFormat.currency(symbol: 'PHP ').format(transaction.amount)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Transaction ID: ${transaction.id}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close bottom sheet
                    Routes.navigateToWallet(context, clearStack: true);
                    context
                        .read<SendMoneyCubit>()
                        .resetState(); // Reset state after navigation
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
