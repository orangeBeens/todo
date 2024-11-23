import 'package:flutter/material.dart';

enum AppThemeType { darkGrey, navy, light }

class AppThemeNotifier extends ChangeNotifier {
  AppThemeType _currentTheme = AppThemeType.light;
  
  AppThemeType get currentTheme => _currentTheme;
  
  ThemeData get themeData {
    switch (_currentTheme) {
      case AppThemeType.darkGrey:
        return ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.grey[800],
          scaffoldBackgroundColor: Colors.grey[900],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey[800],
            foregroundColor: Colors.white,
          ),
          tabBarTheme: const TabBarTheme(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.grey[700],
            foregroundColor: Colors.white,
          ),
        );
        
      case AppThemeType.navy:
        return ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF1A237E),
          scaffoldBackgroundColor: const Color(0xFF0D1B3E),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A237E),
            foregroundColor: Colors.white,
          ),
          tabBarTheme: const TabBarTheme(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF1A237E),
            foregroundColor: Colors.white,
          ),
        );
        
      case AppThemeType.light:
        return ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey[900],
          ),
          tabBarTheme: TabBarTheme(
            labelColor: Colors.grey[900],
            unselectedLabelColor: Colors.grey[700],
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
          ),
        );
    }
  }
  
  void setTheme(AppThemeType theme) {
    _currentTheme = theme;
    notifyListeners();
  }
}