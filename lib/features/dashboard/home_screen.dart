import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rmw/core/models/dashboard_summary.dart';
import 'package:rmw/core/models/account.dart';

import 'package:rmw/features/transactions/add_transaction_screen.dart';
import 'package:rmw/features/dashboard/dashboard_provider.dart';
import 'package:rmw/features/transactions/add_transaction_provider.dart';
import 'package:rmw/shared/utils/app_theme.dart';
import 'package:rmw/shared/utils/currency_util.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardSummary = ref.watch(dashboardSummaryProvider);
    final accountsAsyncValue = ref.watch(accountsProvider);

    return dashboardSummary.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (summary) => _HomeScreenState(summary, accountsAsyncValue),
    );
  }

}

class _HomeScreenState extends StatelessWidget {
  final DashboardSummary summary;
  final AsyncValue<List<Account>> accounts;
  const _HomeScreenState(this.summary, this.accounts);

  Map<String, dynamic> _buildComparison(double current, double previous) {
      if (previous == 0 && current > 0) {
        return {
          'text': 'Up from 0',
          'icon': Icons.arrow_upward,
          'color': Colors.green,
        };
      }
      if (current == 0 && previous > 0) {
        return {
          'text': 'Down from ${previous.toStringAsFixed(2)}',
          'icon': Icons.arrow_downward,
          'color': Colors.red,
        };
      }
      if (current == 0 && previous == 0) {
        return {
          'text': 'No spending',
          'icon': Icons.remove,
          'color': Colors.grey,
        };
      }

      double percentageChange = ((current - previous) / previous) * 100;

      if (percentageChange.abs() < 1) {
        return {
          'text': 'Same as before',
          'icon': Icons.remove,
          'color': Colors.grey,
        };
      } else if (percentageChange > 0) {
        return {
          'text': '${percentageChange.toStringAsFixed(0)}% increase',
          'icon': Icons.arrow_upward,
          'color': Colors.green,
        };
      } else {
        return {
          'text': '${percentageChange.abs().toStringAsFixed(0)}% decrease',
          'icon': Icons.arrow_downward,
          'color': Colors.red,
        };
      }
  }

  @override
  Widget build(BuildContext context) {
    final monthComparison = _buildComparison(summary.thisMonthSpend, summary.previousMonthSpend);
    final weekComparison = _buildComparison(summary.thisWeekSpend, summary.previousWeekSpend);
    final todayComparison = _buildComparison(summary.todaySpend, summary.previousDaySpend);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,

      // application top bar
      appBar: AppBar(
        title: const Text(
          'Roast My Wallet',
          style: AppTheme.heading1,
        ),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: AppTheme.secondaryTextColor,
            ),
            onPressed: () {
              print("Notifications tapped");
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: AppTheme.secondaryTextColor,
              size: 30,
            ),
            onPressed: () {
              print("Profile tapped");
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      // center screen
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /*
            three children:
            1. spends this month
            2. spends this week
            3. spends today
            */
            _buildSpendingCard(
              context: context,
              title: 'Spends this month',
              amount: '₹${summary.thisMonthSpend.toStringAsFixed(2)}',
              comparisonText: monthComparison['text'],
              comparisonIcon: monthComparison['icon'],
              comparisonColor: monthComparison['color']
            ),

            const SizedBox(height: 16.0),
            _buildSpendingCard(
              context: context,
              title: 'Spends this week',
              amount: '₹${summary.thisWeekSpend.toStringAsFixed(2)}',
              comparisonText: weekComparison['text'],
              comparisonIcon: weekComparison['icon'],
              comparisonColor: weekComparison['color']
            ),

            const SizedBox(height: 16.0),
            _buildSpendingCard(
              context: context,
              title: 'Spends today',
              amount: '₹${summary.todaySpend.toStringAsFixed(2)}',
              comparisonText: todayComparison['text'],
              comparisonIcon: todayComparison['icon'],
              comparisonColor: todayComparison['color']
            ),

            const SizedBox(height: 24.0),

            // my accounts
            const Text("My Accounts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            accounts.when(
              loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
              error: (err, stack) => Text('Error: $err'),
              data: (accounts) => _buildAccountsList(accounts),
            ),
          ],
        ),
      ),

      // add transaction button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
          print("FAB tapped");
        },
        backgroundColor: AppTheme.accentColor,
        child: const Icon(Icons.add, color: Colors.white),
      )

    );
  }

  // the spending cards
  Widget _buildSpendingCard({
    required BuildContext context,
    required String title,
    required String amount,
    required String comparisonText,
    required IconData comparisonIcon,
    required Color comparisonColor
  }) {
    return Card(
      color: AppTheme.cardBackgroundColor,
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTheme.subheading,
            ),
            const SizedBox(height: 8.0),
            Text(
              amount,
              style: AppTheme.heading1,
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Icon(comparisonIcon, color: comparisonColor, size: 16.0),
                const SizedBox(width: 4.0),
                Text(
                  comparisonText,
                  style: AppTheme.subheading,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountsList(List<Account> accounts) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          final account = accounts[index];
          return _buildAccountCard(account);
        },
      ),
    );
  }

  Widget _buildAccountCard(Account account) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.cardBackgroundColor,
        borderRadius: AppTheme.cardBorderRadius,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.account_balance, color: AppTheme.primaryTextColor),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(account.name, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              Text(
                '${CurrencyUtil.getCurrencySymbol(account.currency)} ${account.balance?.toStringAsFixed(2) ?? '0.00'}',
                style: const TextStyle(color: AppTheme.secondaryTextColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
