import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // current select nav item
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print("Tapped index: $index");
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryTextColor = Colors.black87;
    const Color secondaryTextColor = Colors.grey;
    const Color accentColor = Colors.black;
    const Color backgroundColor = Color(0xFFF5F5F5);
    const Color cardBackgroundColor = Colors.white;
    const Color increaseColor = Colors.green;
    const Color decreaseColor = Colors.red;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Roast My Wallet',
          style: TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: secondaryTextColor),
            onPressed: () {
              print("Notifications tapped");
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: secondaryTextColor, size: 30),
            onPressed: () {
              print("Profile tapped");
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSpendingCard(
              context: context,
              title: 'Spends this month',
              amount: '\$2,456.78',
              comparisonText: '12% from last month',
              comparisonIcon: Icons.arrow_upward,
              comparisonColor: increaseColor,
              cardBackgroundColor: cardBackgroundColor,
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
            ),
            const SizedBox(height: 16.0),
            _buildSpendingCard(
              context: context,
              title: 'Spends this week',
              amount: '\$456.32',
              comparisonText: '8% from last week',
              comparisonIcon: Icons.arrow_downward,
              comparisonColor: decreaseColor,
              cardBackgroundColor: cardBackgroundColor,
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
            ),
            const SizedBox(height: 16.0),
            _buildSpendingCard(
              context: context,
              title: 'Spends today',
              amount: '\$65.40',
              comparisonText: 'Same as yesterday',
              comparisonIcon: Icons.remove,
              comparisonColor: secondaryTextColor,
              cardBackgroundColor: cardBackgroundColor,
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("FAB tapped");
        },
        backgroundColor: accentColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: accentColor,
        unselectedItemColor: secondaryTextColor,
        backgroundColor: cardBackgroundColor,
        type: BottomNavigationBarType.fixed, 
        showUnselectedLabels: true,
        elevation: 5.0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        onTap: _onItemTapped,
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
    required Color comparisonColor,
    required Color cardBackgroundColor,
    required Color primaryTextColor,
    required Color secondaryTextColor,
  }) {
    return Card(
      color: cardBackgroundColor,
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              amount,
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Icon(
                  comparisonIcon,
                  color: comparisonColor,
                  size: 16.0,
                ),
                const SizedBox(width: 4.0),
                Text(
                  comparisonText,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}