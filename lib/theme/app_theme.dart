import 'package:flutter/material.dart';

class AppPalette {
  static const Color primary = Color(0xFFBB86FC);
  static const Color cardDark = Color(0xFF121212);
  static const Color cardLight = Color(0xFFF5F5F5);
  static const Color sheetDark = Color(0xFF1E1E1E);
  static const Color sheetLight = Colors.white;
  static const Color deleteRed = Color(0xFFD32F2F);
  static const Color iconGrey = Color(0xFF757575);
  static const Color textGrey = Color(0xFFBDBDBD);

  static const List<Map<String, dynamic>> noteColors = [
    {'name': 'White', 'color': 'ffffff'},
    {'name': 'Default', 'color': '2C2C2C'},
    {'name': 'Purple', 'color': '6200EE'},
    {'name': 'Teal', 'color': '03DAC5'},
    {'name': 'Pink', 'color': 'FF0266'},
    {'name': 'Amber', 'color': 'FFC107'},
    {'name': 'Blue', 'color': '3700B3'},
  ];
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppPalette.sheetLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.sheetLight,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(fillColor: AppPalette.cardLight),
    colorScheme: ColorScheme.light(secondary: AppPalette.primary),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.black87),
      bodyLarge: TextStyle(color: Colors.black),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppPalette.sheetLight,
      modalBackgroundColor: AppPalette.sheetLight,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppPalette.sheetDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPalette.sheetDark,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(fillColor: AppPalette.cardDark),
    colorScheme: ColorScheme.dark(secondary: AppPalette.primary),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.white70),
      bodyLarge: TextStyle(color: Colors.white),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppPalette.sheetDark,
      modalBackgroundColor: AppPalette.sheetDark,
    ),
  );
}
