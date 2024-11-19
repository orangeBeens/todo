import 'package:flutter/material.dart';
import 'screens/todo_list_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppThemeType _currentTheme = AppThemeType.light;

  void updateTheme(AppThemeType newTheme) {
    setState(() {
      _currentTheme = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo Apps',
      theme: switch (_currentTheme) {
        AppThemeType.darkGrey => AppTheme.getDarkGreyTheme(),
        AppThemeType.navy => AppTheme.getNavyTheme(),
        AppThemeType.light => AppTheme.getLightTheme(),
      },
      home: const TodoListScreen(),
    );
  }
}