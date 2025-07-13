import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/transaction.dart';
import '../cubits/wallet_cubit.dart';

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<WalletCubit>()..getTransactions(),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Transaction History'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Local Transactions'),
                Tab(text: 'API Transactions'),
              ],
            ),
          ),
          body: BlocBuilder<WalletCubit, WalletState>(
            builder: (context, state) {
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
                final localTransactions =
                    state.transactions
                        .where((t) => t.source == TransactionSource.local)
                        .toList();
                final apiTransactions =
                    state.transactions
                        .where((t) => t.source == TransactionSource.api)
                        .toList();

                return TabBarView(
                  children: [
                    _buildTransactionList(context, localTransactions),
                    _buildTransactionList(context, apiTransactions),
                  ],
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context, Transaction transaction) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');
    final isSuccess = transaction.status.toLowerCase() == 'completed';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              isSuccess
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
          child: Icon(
            isSuccess ? Icons.check : Icons.pending,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        title: Text(
          transaction.description,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${transaction.id}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              dateFormat.format(transaction.date),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Status: ${transaction.status}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color:
                    isSuccess
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: Text(
          NumberFormat.currency(symbol: 'PHP ').format(transaction.amount),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color:
                isSuccess
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () => _showTransactionDetails(context, transaction),
      ),
    );
  }

  Widget _buildTransactionList(
    BuildContext context,
    List<Transaction> transactions,
  ) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.history, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No transactions yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              transactions.isEmpty
                  ? 'Your transaction history will appear here'
                  : 'No transactions found',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionCard(context, transaction);
      },
    );
  }

  void _showTransactionDetails(BuildContext context, Transaction transaction) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm:ss');
    final isSuccess = transaction.status.toLowerCase() == 'completed';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          isSuccess
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.secondary,
                      child: Icon(
                        isSuccess ? Icons.check : Icons.pending,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.description,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            NumberFormat.currency(
                              symbol: 'PHP ',
                            ).format(transaction.amount),
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color:
                                  isSuccess
                                      ? Theme.of(context).colorScheme.error
                                      : Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Transaction Details',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(context, 'ID', transaction.id),
                _buildDetailRow(
                  context,
                  'Date',
                  dateFormat.format(transaction.date),
                ),
                _buildDetailRow(context, 'Status', transaction.status),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
