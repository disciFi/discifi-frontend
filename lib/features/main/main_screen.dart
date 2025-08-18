import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rmw/features/dashboard/home_screen.dart';
import 'package:rmw/features/insights/insights_screen.dart';
import 'package:rmw/features/budgets/budgets_screen.dart';
import 'package:rmw/features/transactions/transactions_screen.dart';
import 'package:rmw/features/settings/settings_screen.dart';
import 'main_screen_provider.dart';
import 'package:rmw/shared/utils/app_theme.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  // bottom navigation bar
  final _screens = const [
    HomeScreen(),
    TransactionsScreen(),
    InsightsScreen(),
    BudgetsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(mainScreenIndexProvider);

    return Scaffold(
      body: _screens[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Budgets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: AppTheme.accentColor,
        unselectedItemColor: AppTheme.secondaryTextColor,
        backgroundColor: AppTheme.cardBackgroundColor,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        onTap: (index) {
          ref.read(mainScreenIndexProvider.notifier).state = index;
        },
      ),
    );
  }
}
