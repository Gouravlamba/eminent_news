import 'package:flutter/material.dart';

class AppTheme {
  // Brand colors from React app
  static const Color primaryRed = Color(0xFFF40607);
  static const Color darkGray = Color(0xFF1F1F1F);
  static const Color lightGray = Color(0xFFF5F5F5);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryRed,
      primary: primaryRed,
      secondary: darkGray,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryRed,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: lightGray,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: darkGray,
        fontFamilyFallback: ['droid-serif'], // Add fallback font
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: darkGray,
        fontFamilyFallback: ['droid-serif'],
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: darkGray,
        fontFamilyFallback: ['droid-serif'],
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: darkGray,
        fontFamilyFallback: ['droid-serif'],
      ),
    ),
    // Use default system font (no custom fonts)
    fontFamily: 'droid-serif', // Set default font
  );
}
