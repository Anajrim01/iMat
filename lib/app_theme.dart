import 'package:flutter/material.dart';

class AppTheme {
  static const double paddingTiny = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMediumSmall = 12.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingHuge = 32.0;

  static const double borderRadius = 8.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusHuge = 32.0;

  static ColorScheme colorScheme = ColorScheme.fromSeed(seedColor: Colors.white, 
    primary: Color(0xFF56D05C), secondary: Color(0xFFF3E5F5)
  );

  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    titleSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 16),
    bodyMedium: TextStyle(fontSize: 14),
    bodySmall: TextStyle(fontSize: 12),
  ); 
}
