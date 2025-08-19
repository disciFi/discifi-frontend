class CurrencyUtil {
  static const Map<String, String> _currencySymbols = {
    'INR': '₹',
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
  };

  static String getCurrencySymbol(String code) {
    return _currencySymbols[code.toUpperCase()] ?? code;
  }
}