import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // --- COLORS ---
  static const Color primaryTextColor = Colors.black87;
  static const Color secondaryTextColor = Colors.grey;
  static const Color accentColor = Colors.black;
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardBackgroundColor = Colors.white;
  static const Color increaseColor = Colors.green;
  static const Color decreaseColor = Colors.red;


  // --- TEXT STYLES ---
  static const TextStyle heading1 = TextStyle(
    color: primaryTextColor,
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subheading = TextStyle(
    color: secondaryTextColor,
    fontSize: 14.0,
  );


  // --- BORDERS ---
  static final BorderRadius cardBorderRadius = BorderRadius.circular(12.0);
}