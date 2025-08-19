import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rmw/features/budgets/budgets_provider.dart';
import 'package:rmw/shared/utils/app_theme.dart';
import '../../core/models/budget.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsyncValue = ref.watch(budgetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Budgets', style: TextStyle(color: AppTheme.primaryTextColor)),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: budgetsAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (budgets) {
          if (budgets.isEmpty) {
            return const Center(child: Text('You haven\'t set any budgets for this month.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              final budget = budgets[index];
              return _buildBudgetCard(budget);
            },
          );
        },
      ),
    );
  }

  Widget _buildBudgetCard(Budget budget) {
    final double progress = budget.budgetAmount > 0 ? budget.amountSpent / budget.budgetAmount : 0;
    final Color progressColor = progress > 0.8 ? AppTheme.decreaseColor : AppTheme.increaseColor;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: AppTheme.cardBorderRadius),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(budget.categoryName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Spent: ₹${budget.amountSpent.toStringAsFixed(2)}', style: const TextStyle(color: AppTheme.primaryTextColor)),
                Text('Budget: ₹${budget.budgetAmount.toStringAsFixed(2)}', style: const TextStyle(color: AppTheme.secondaryTextColor)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Remaining: ₹${budget.amountRemaining.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.w500, color: progress > 1 ? AppTheme.decreaseColor : AppTheme.primaryTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}