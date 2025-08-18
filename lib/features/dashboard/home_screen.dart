import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rmw/core/models/dashboard_summary.dart';

import 'package:rmw/features/transactions/add_transaction_screen.dart';
import 'package:rmw/features/dashboard/dashboard_provider.dart';
import 'package:rmw/shared/utils/app_theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardSummary = ref.watch(dashboardSummaryProvider);

    return dashboardSummary.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (summary) => _HomeScreenState(summary),
    );
  }

}

class _HomeScreenState extends StatelessWidget {
  final DashboardSummary summary;
  const _HomeScreenState(this.summary);

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
          style: TextStyle(
            color: AppTheme.primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
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
      ),

      /*
      bottom navigation bar:
      1. home - current screen
      2. transactions - shows all the transactions
      3. ai insights - shows all the ai insights aggregated
      4. budgets - shows the budgets that were created
      5. settings
      */
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          // home
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          // transactions
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Transactions',
          ),
          // ai insights
          BottomNavigationBarItem(
            icon: Icon(Icons.insights), // Icon for AI Insights
            label: 'Insights',
          ),
          // budgets screen
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Budgets',
          ),
          // settings screen
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
        // currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.accentColor,
        unselectedItemColor: AppTheme.secondaryTextColor,
        backgroundColor: AppTheme.cardBackgroundColor,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 5.0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        // onTap: _onItemTapped,
      ),
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
              style: TextStyle(color: AppTheme.secondaryTextColor, fontSize: 14.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              amount,
              style: TextStyle(
                color: AppTheme.primaryTextColor,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Icon(comparisonIcon, color: comparisonColor, size: 16.0),
                const SizedBox(width: 4.0),
                Text(
                  comparisonText,
                  style: TextStyle(color: AppTheme.secondaryTextColor, fontSize: 14.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
