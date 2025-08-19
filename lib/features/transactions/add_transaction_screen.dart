import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rmw/core/api/api_provider.dart';
import 'package:rmw/core/models/account.dart';
import 'package:rmw/core/models/category.dart';
import 'package:rmw/features/dashboard/dashboard_provider.dart';
import 'package:rmw/features/transactions/add_transaction_provider.dart';
import 'package:rmw/features/transactions/transactions_provider.dart';
import 'package:rmw/shared/utils/app_theme.dart';
import 'package:rmw/shared/utils/currency_util.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _titleController = TextEditingController();
  String _rawAmountInput = "";
  Category? _selectedCategory;
  Account? _selectedAccount;
  DateTime _selectedDate = DateTime.now();
  String _transactionType = 'Expense';

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveTransaction() async {
    final amountValue = double.tryParse(_rawAmountInput);
    if (amountValue == null || amountValue <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')),
      );
      return;
    }
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a title.')));
      return;
    }
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category.')),
      );
      return;
    }
    if (_selectedAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an account.')),
      );
      return;
    }

    final transactionData = {
      'title': _titleController.text.trim(),
      'amount': amountValue,
      'type': _transactionType,
      'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
      'accountId': _selectedAccount!.id,
      'categoryId': _selectedCategory!.id,
      'isRecurring': false,
    };

    try {
      await ref.read(apiServiceProvider).createTransaction(transactionData);

      ref.invalidate(dashboardSummaryProvider);
      ref.invalidate(transactionsProvider);
      ref.invalidate(accountsProvider);

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppTheme.cardBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.cardBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Add Transaction',
          style: TextStyle(
            color: AppTheme.primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAmountInput(),
            const SizedBox(height: 16),
            _buildTransactionTypeSelector(),
            const SizedBox(height: 16),
            _buildTextInput(
              controller: _titleController,
              label: 'Title',
              hint: 'What\'s this for?',
            ),
            const SizedBox(height: 16),

            // categories dropdown
            categoriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error loading categories: $err'),
              data:
                  (categories) => _buildSelector(
                    label: 'Category',
                    value: _selectedCategory?.name ?? 'Select Category',
                    icon: Icons.category_outlined,
                    onTap: () => _showCategoryPicker(categories),
                  ),
            ),
            const SizedBox(height: 16),

            // accounts dropdown
            accountsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error loading accounts: $err'),
              data:
                  (accounts) => _buildSelector(
                    label: 'From Account',
                    value: _selectedAccount?.name ?? 'Select Account',
                    icon: Icons.account_balance_wallet_outlined,
                    onTap: () => _showAccountPicker(accounts),
                  ),
            ),
            const SizedBox(height: 16),

            _buildSelector(
              label: 'Date',
              value: DateFormat.yMMMd().format(_selectedDate),
              icon: Icons.calendar_today_outlined,
              onTap: _showDatePickerDialog,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _saveTransaction,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentColor,
            foregroundColor: AppTheme.cardBackgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: AppTheme.cardBorderRadius,
            ),
          ),
          child: const Text('Save Transaction'),
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    final currencyCode = _selectedAccount?.currency ?? 'INR';

    return _buildInputContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Amount', style: AppTheme.subheading),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                CurrencyUtil.getCurrencySymbol(currencyCode),
                style: AppTheme.subheading.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: TextField(
                  style: AppTheme.heading1.copyWith(fontSize: 32),
                  decoration: const InputDecoration(
                    hintText: "0.00",
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (value) {
                    _rawAmountInput = value;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _transactionType = 'Expense'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color:
                      _transactionType == 'Expense'
                          ? AppTheme.accentColor
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Center(
                  child: Text(
                    'Expense',
                    style: TextStyle(
                      color:
                          _transactionType == 'Expense'
                              ? Colors.white
                              : AppTheme.primaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _transactionType = 'Income'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color:
                      _transactionType == 'Income'
                          ? AppTheme.increaseColor
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Center(
                  child: Text(
                    'Income',
                    style: TextStyle(
                      color:
                          _transactionType == 'Income'
                              ? Colors.white
                              : AppTheme.primaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return _buildInputContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTheme.subheading),
          TextField(
            controller: controller,
            style: const TextStyle(
              color: AppTheme.primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppTheme.secondaryTextColor.withValues(alpha: 0.7),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelector({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return _buildInputContainer(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTheme.subheading),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  icon,
                  color: AppTheme.primaryTextColor.withValues(alpha: .8),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: AppTheme.primaryTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppTheme.secondaryTextColor.withValues(alpha: .7),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: child,
    );
  }

  void _showCategoryPicker(List<Category> categories) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return ListTile(
              title: Text(category.name),
              onTap: () {
                setState(() => _selectedCategory = category);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _showAccountPicker(List<Account> accounts) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: accounts.length,
          itemBuilder: (context, index) {
            final account = accounts[index];
            return ListTile(
              title: Text(account.name),
              subtitle: Text(
                '${account.currency} - Balance: ${account.balance.toStringAsFixed(2) ?? 'N/A'}',
              ),
              onTap: () {
                setState(() => _selectedAccount = account);
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  Future<void> _showDatePickerDialog() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() => _selectedDate = pickedDate);
    }
  }
}
