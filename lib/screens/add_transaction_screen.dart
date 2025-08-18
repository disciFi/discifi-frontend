import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  String _rawAmountInput = "";
  Map<String, String> _selectedCurrency = {'symbol': '\$', 'code': 'USD'};
  String? _selectedCategory = "Food & Drinks";
  String? _selectedAccount = "None";
  DateTime _selectedDate = DateTime.now();
  String _currencySearchQuery = "";

  final List<String> _categories = [
    "Food & Drinks",
    "Groceries",
    "Transport",
    "Shopping",
    "Bills",
    "Entertainment",
    "Other",
  ];

  final List<String> _accounts = [
    "Main Card •••• 4567",
    "Savings Account",
    "Cash",
  ];

  final List<Map<String, String>> _currencies = [
    {'symbol': '\$', 'code': 'USD'},
    {'symbol': '€', 'code': 'EUR'},
    {'symbol': '£', 'code': 'GBP'},
    {'symbol': '₹', 'code': 'INR'},
    {'symbol': '¥', 'code': 'JPY'},
    {'symbol': '¥', 'code': 'JPY'},
    {'symbol': '¥', 'code': 'JPY'},
    {'symbol': '¥', 'code': 'JPY'},
    {'symbol': '¥', 'code': 'JPY'},
    {'symbol': '¥', 'code': 'JPY'},
    {'symbol': '¥', 'code': 'JPY'},
    {'symbol': '¥', 'code': 'JPY'},
    {'symbol': '¥', 'code': 'JPY'},
    {'symbol': '¥', 'code': 'JPY'},
    {'symbol': '¥', 'code': 'JPY'},
    {'symbol': '¥', 'code': 'JPY'}
  ];

  String get _formattedAmountDisplay {
    if (_rawAmountInput.isEmpty) {
      return "0.00";
    }

    double value = double.tryParse(_rawAmountInput) ?? 0.0;
    return NumberFormat.currency(symbol: '', decimalDigits: 2).format(value);
    // return value.toStringAsFixed(2);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToFormat = DateTime(date.year, date.month, date.day);

    String dayString;
    if (dateToFormat == today) {
      dayString = "Today";
    } else if (dateToFormat == yesterday) {
      dayString = "Yesterday";
    } else {
      dayString = DateFormat('MMM d').format(date);
    }
    return "$dayString, ${DateFormat.jm().format(date)}";
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryTextColor = Colors.black87;
    const Color secondaryTextColor = Colors.grey;
    const Color inputBackgroundColor = Color(0xFFF5F5F5);
    const Color screenBackgroundColor = Colors.white;
    const Color cardBackgroundColor = Colors.white;
    const Color buttonColor = Colors.black;
    const Color buttonTextColor = Colors.white;

    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: screenBackgroundColor,
        elevation: 0,

        // back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),

        title: const Text(
          'Add Transaction',
          style: TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          // cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: secondaryTextColor, fontSize: 16),
            ),
          ),
          const SizedBox(width: 8), // Padding for the button
        ],
      ),

      // center
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // amount
            _buildAmountInput(primaryTextColor, secondaryTextColor),
            const SizedBox(height: 16),

            // title of the transaction
            _buildTextInput(
              controller: _titleController,
              label: 'Title',
              hint: 'What\'s this for?',
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
            ),
            const SizedBox(height: 16),

            // category of the transaction
            _buildSelector(
              label: 'Category',
              value: _selectedCategory ?? 'Select Category',
              icon: Icons.fastfood,
              onTap: _showCategoryPicker,
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
            ),
            const SizedBox(height: 16),

            // account of the transaction
            _buildSelector(
              label: 'From Account',
              value: _selectedAccount ?? 'Select Account',
              icon: Icons.account_balance_wallet_outlined,
              onTap: _showAccountPicker,
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
            ),
            const SizedBox(height: 16),

            // date of the transaction
            _buildSelector(
              label: 'Date',
              value: _formatDate(_selectedDate),
              icon: Icons.calendar_today_outlined,
              onTap: _showDatePickerDialog,
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
            ),
            const SizedBox(height: 16),

            // optional notes for the transaction
            _buildTextInput(
              controller: _noteController,
              label: 'Note (Optional)',
              hint: 'Add note',
              maxLines: 3,
              primaryTextColor: primaryTextColor,
              secondaryTextColor: secondaryTextColor,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),

      // bottom button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _saveTransaction,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: buttonTextColor,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Text('Save Transaction'),
        ),
      ),
    );
  }

  void _showCurrencyPicker() {
    _currencySearchQuery = "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final Color primaryTextColor = Theme.of(context).colorScheme.onSurface;
            final Color secondaryTextColor = Theme.of(context).hintColor;
            final Color selectedColor = Theme.of(context).colorScheme.primary;
            final Color selectedTileBackgroundColor = Colors.grey.shade200;
            final Color borderColor = Theme.of(context).dividerColor;
            final Color searchFocusBorderColor = Theme.of(context).colorScheme.primary;

            final filteredCurrencies =
                _currencies.where((currency) {
                  final query = _currencySearchQuery.toLowerCase();
                  final symbol = currency['symbol']!.toLowerCase();
                  final code = currency['code']!.toLowerCase();
                  return symbol.contains(query) || code.contains(query);
                }).toList();

            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title
                  Text(
                    'Select Currency',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryTextColor),
                  ),
                  const SizedBox(height: 16),

                  // search field
                  TextField(
                    style: TextStyle(color: primaryTextColor),
                    onChanged: (value) {
                      setModalState(() {
                        _currencySearchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search (e.g., USD or \$)',
                      hintStyle: TextStyle(color: secondaryTextColor),
                      prefixIcon: Icon(Icons.search, size: 20, color: secondaryTextColor),
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: searchFocusBorderColor,
                          width: 1.5
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // box containing the available currencies
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredCurrencies.length,
                      itemBuilder: (context, index) {
                        final currency = filteredCurrencies[index];
                        final isSelected =
                            currency['code'] == _selectedCurrency['code'];

                        return ListTile(
                          leading: Text(
                            currency['symbol']!,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: primaryTextColor
                            ),
                          ),
                          title: Text(currency['code']!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: primaryTextColor)),
                          trailing:
                              isSelected
                                  ? Icon(
                                    Icons.check_circle,
                                    color: selectedColor,
                                  )
                                  : null,
                          onTap: () {
                            setState(() {
                              _selectedCurrency = currency;
                            });
                            Navigator.pop(context);
                          },
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          selected: isSelected,
                          selectedTileColor: selectedTileBackgroundColor,
                          splashColor: Colors.grey.shade300,
                          focusColor: Colors.grey.shade300,
                          hoverColor: Colors.grey.shade100,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // builders
  // --- Widget Builders for Input Fields ---

  Widget _buildAmountInput(Color primaryColor, Color secondaryColor) {
    return _buildInputContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Amount', style: TextStyle(color: secondaryColor, fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              // to pick the currency
              GestureDetector(
                onTap: _showCurrencyPicker,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Text(
                    _selectedCurrency['symbol']!, // Display selected currency symbol
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // numpad
              Expanded(
                child: GestureDetector(
                  onTap: _showNumpad,
                  child: Text(
                    _formattedAmountDisplay,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    required Color primaryTextColor,
    required Color secondaryTextColor,
  }) {
    return _buildInputContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title
          Text(
            label,
            style: TextStyle(color: secondaryTextColor, fontSize: 14),
          ),

          // field to enter
          TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(
              color: primaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),

            // placeholder
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: secondaryTextColor.withValues(alpha: 0.7),
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
    required Color primaryTextColor,
    required Color secondaryTextColor,
  }) {
    return _buildInputContainer(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: secondaryTextColor, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  icon,
                  color: primaryTextColor.withValues(alpha: 0.8),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  // Text takes available space
                  child: Text(
                    value,
                    style: TextStyle(
                      color: primaryTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: secondaryTextColor.withValues(alpha: 0.7),
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

  // --- Action Handlers ---

  void _showCategoryPicker() {
    // TODO: Replace with a nicer bottom sheet or modal popup
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            return ListTile(
              title: Text(category),
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
    print("Show category picker");
  }

  void _showAccountPicker() {
    // TODO: Replace with a nicer bottom sheet or modal popup
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _accounts.length,
          itemBuilder: (context, index) {
            final account = _accounts[index];
            return ListTile(
              title: Text(account),
              onTap: () {
                setState(() {
                  _selectedAccount = account;
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
    print("Show account picker");
  }

  Future<void> _showDatePickerDialog() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000), // Arbitrary start date
      lastDate: DateTime(2101), // Arbitrary end date
      // Optional: Customize colors to match theme
      // builder: (context, child) {
      //   return Theme(
      //     data: Theme.of(context).copyWith(
      //       colorScheme: ColorScheme.light(
      //         primary: buttonColor, // header background color
      //         onPrimary: buttonTextColor, // header text color
      //         onSurface: primaryTextColor, // body text color
      //       ),
      //       textButtonTheme: TextButtonThemeData(
      //         style: TextButton.styleFrom(
      //           foregroundColor: buttonColor, // button text color
      //         ),
      //       ),
      //     ),
      //     child: child!,
      //   );
      // },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  // Inside _AddTransactionScreenState

  void _showNumpad() {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allows bottom sheet to take more height if needed
      backgroundColor: Colors.white, // Numpad background
      builder:
          (context) => Padding(
            // Add padding to avoid system intrusions (notch, navigation bar)
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: _buildNumpad(), // Build the numpad widget
          ),
    );
  }

  // --- Numpad Input Handlers ---
  void _onNumpadDigit(String digit) {
    setState(() {
      // Handle leading zero
      if (_rawAmountInput == "0" && digit != ".") {
        _rawAmountInput = digit;
        return;
      }
      // Prevent multiple zeros at start
      if (_rawAmountInput == "" && digit == "0") {
        _rawAmountInput = "0"; // Allow single starting zero before decimal
        return;
      }

      // Limit decimal places to 2
      if (_rawAmountInput.contains('.') &&
          _rawAmountInput.split('.').last.length >= 2) {
        return;
      }

      // TODO: Add max length check if needed
      // if (_rawAmountInput.length > 10) return;

      _rawAmountInput += digit;
    });
  }

  void _onNumpadDecimal() {
    setState(() {
      // Allow decimal only if not already present
      if (!_rawAmountInput.contains('.')) {
        // Handle case where input is empty - prepend "0"
        if (_rawAmountInput.isEmpty) {
          _rawAmountInput = "0.";
        } else {
          _rawAmountInput += '.';
        }
      }
    });
  }

  void _onNumpadBackspace() {
    setState(() {
      if (_rawAmountInput.isNotEmpty) {
        _rawAmountInput = _rawAmountInput.substring(
          0,
          _rawAmountInput.length - 1,
        );
      }
    });
  }

  void _onNumpadDone() {
    // Optional: Add validation here before closing if needed
    if (_rawAmountInput.endsWith('.')) {
      _rawAmountInput = _rawAmountInput.substring(
        0,
        _rawAmountInput.length - 1,
      ); // Remove trailing decimal
    }
    if (_rawAmountInput == "0") {
      _rawAmountInput = ""; // Clear if only zero left
    }
    Navigator.pop(context); // Close the bottom sheet
  }

  // --- Numpad Widget Builder ---
  Widget _buildNumpad() {
    // Customize colors and styles as needed
    const Color numpadButtonColor = Colors.black87;
    const double buttonHeight = 60.0;

    Widget buildButton(
      String text, {
      VoidCallback? onPressed,
      IconData? icon,
      bool isDone = false,
      bool isBackspace = false,
    }) {
      return Expanded(
        child: SizedBox(
          height: buttonHeight,
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: numpadButtonColor,
              shape:
                  const CircleBorder(), // Make buttons circular or rectangular
              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
            ),
            onPressed: onPressed,
            child:
                icon != null
                    ? Icon(
                      icon,
                      size: 28,
                      color: isBackspace ? Colors.redAccent : numpadButtonColor,
                    )
                    : Text(
                      text,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight:
                            isDone ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Take only needed vertical space
        children: [
          // Optional: Display current input in the numpad sheet
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Text(
          //      "${_selectedCurrency['symbol']} ${_formattedAmountDisplay}",
          //      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
          //   ),
          // ),
          Row(
            children: [
              buildButton('1', onPressed: () => _onNumpadDigit('1')),
              buildButton('2', onPressed: () => _onNumpadDigit('2')),
              buildButton('3', onPressed: () => _onNumpadDigit('3')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              buildButton('4', onPressed: () => _onNumpadDigit('4')),
              buildButton('5', onPressed: () => _onNumpadDigit('5')),
              buildButton('6', onPressed: () => _onNumpadDigit('6')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              buildButton('7', onPressed: () => _onNumpadDigit('7')),
              buildButton('8', onPressed: () => _onNumpadDigit('8')),
              buildButton('9', onPressed: () => _onNumpadDigit('9')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              buildButton('.', onPressed: _onNumpadDecimal),
              buildButton('0', onPressed: () => _onNumpadDigit('0')),
              buildButton(
                '',
                icon: Icons.backspace_outlined,
                onPressed: _onNumpadBackspace,
                isBackspace: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Add a Done button to close explicitly
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
          //   onPressed: _onNumpadDone,
          //   child: const Text('Done', style: TextStyle(fontSize: 18)),
          // ),
        ],
      ),
    );
  }

  // --- Make sure to update _saveTransaction ---
  void _saveTransaction() {
    // --- Validation ---
    double? amountValue = double.tryParse(_rawAmountInput);
    if (amountValue == null || amountValue <= 0) {
      // Show error message (e.g., using SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount greater than 0.'),
        ),
      );
      return;
    }
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title for the transaction.'),
        ),
      );
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

    // --- Data Preparation ---
    print("Saving transaction:");
    print("  Amount: $amountValue"); // Use the parsed double value
    print("  Currency: ${_selectedCurrency['code']}"); // Save currency code
    print("  Title: ${_titleController.text.trim()}");
    print("  Category: $_selectedCategory");
    print("  Account: $_selectedAccount");
    print("  Date: $_selectedDate");
    print("  Note: ${_noteController.text.trim()}");

    // TODO: Create a Transaction object and save it properly

    // --- Navigate Back ---
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  // --- Dispose Controllers ---
  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
