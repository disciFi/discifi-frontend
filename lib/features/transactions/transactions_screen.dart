import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'transactions_provider.dart';
import 'package:rmw/shared/utils/app_theme.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsyncValue = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions', style: TextStyle(color: AppTheme.primaryTextColor)),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: transactionsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(child: Text('No transactions yet.'));
          }
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              final isExpense = transaction.type == 'Expense';

              return ListTile(
                leading: CircleAvatar(
                  child: Icon(isExpense ? Icons.arrow_upward : Icons.arrow_downward),
                ),
                title: Text(transaction.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(transaction.category.name),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isExpense ? '-' : '+'}${transaction.account.currency} ${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isExpense ? AppTheme.decreaseColor : AppTheme.increaseColor,
                      ),
                    ),
                    Text(
                      DateFormat.yMMMd().format(transaction.date),
                      style: const TextStyle(fontSize: 12, color: AppTheme.secondaryTextColor),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}