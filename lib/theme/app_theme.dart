import 'package:flutter/material.dart';

enum AppThemeType {
  darkGrey,
  navy,
  light,
}

class AppTheme {
  static ThemeData getDarkGreyTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.grey[900],
      colorScheme: ColorScheme.dark(
        background: Colors.grey[900]!,
        surface: Colors.grey[800]!,
        primary: Colors.blue[400]!,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[850],
        foregroundColor: Colors.white,
      ),
      textTheme: const TextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );
  }

  static ThemeData getNavyTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF1A237E),
      colorScheme: const ColorScheme.dark(
        background: Color(0xFF1A237E),
        surface: Color(0xFF283593),
        primary: Color(0xFF82B1FF),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF283593),
        foregroundColor: Colors.white,
      ),
      textTheme: const TextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
    );
  }

  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        background: Colors.grey[50]!,
        surface: Colors.white,
        primary: Colors.blue,
      ),
    );
  }
}
