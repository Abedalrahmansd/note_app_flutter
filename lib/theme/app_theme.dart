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

  /* static List<Map<String, dynamic>> noteColors = [
    {'name': 'White', 'color': 'ffffff'},
    {'name': 'Default', 'color': '2C2C2C'},
    {'name': 'Primary', 'color': primary.value.toRadixString(16)},
    {'name': 'Purple', 'color': '6200EE'},
    {'name': 'Teal', 'color': '03DAC5'},
    {'name': 'Pink', 'color': 'FF0266'},
    {'name': 'Amber', 'color': 'FFC107'},
    {'name': 'Blue', 'color': '3700B3'},
    {'name': 'Green', 'color': '03DAC6'},
  ]; */

  /* static List<Map<String, dynamic>> noteColors = [
    // {'name': 'Default Dark', 'color': '2C2C2C'},
    {'name': 'White', 'color': 'ffffff'},
    {'name': 'Charcoal', 'color': '333333'},
    {'name': 'Primary', 'color': primary.value.toRadixString(16)},
    {'name': 'Delete Red', 'color': deleteRed.value.toRadixString(16)},
    {'name': 'Midnight', 'color': '191970'},
    {'name': 'Obsidian', 'color': '000000'},
    {'name': 'Graphite', 'color': '424242'},
    {'name': 'Slate', 'color': '4A5568'},
    {'name': 'Deep Ocean', 'color': '005F8C'},
    {'name': 'Ocean', 'color': '3700B3'},
    {'name': 'Sapphire', 'color': '0F52BA'},
    {'name': 'Steel Blue', 'color': '4682B4'},
    {'name': 'Peacock', 'color': '33A1C9'},
    {'name': 'Teal', 'color': '03DAC5'},
    {'name': 'Lagoon', 'color': '20B2AA'},
    {'name': 'Pine', 'color': '01796F'},
    {'name': 'Forest', 'color': '228B22'},
    {'name': 'Emerald', 'color': '50C878'},
    {'name': 'Olive', 'color': '808000'},
    {'name': 'Deep Purple', 'color': '673AB7'},
    {'name': 'Twilight', 'color': '4B0082'},
    {'name': 'Royal', 'color': '7851A9'},
    {'name': 'Berry', 'color': 'E91E63'},
    {'name': 'Crimson', 'color': 'DC143C'},
    {'name': 'Rust', 'color': 'B7410E'},
    {'name': 'Copper', 'color': 'B87333'},
    {'name': 'Wine', 'color': '722F37'},
    {'name': 'Umber', 'color': '635147'},
  ]; */
  static List<Map<String, dynamic>> noteColors = [
    // dark
    {'name': 'Copper', 'color': 'B87333', 'textColor': 'white'},
    {'name': 'Rust', 'color': 'B7410E', 'textColor': 'white'},
    {'name': 'Twilight', 'color': '4B0082', 'textColor': 'white'},
    {'name': 'Deep Ocean', 'color': '005F8C', 'textColor': 'white'},
    {'name': 'Sapphire', 'color': '0F52BA', 'textColor': 'white'},
    {'name': 'Ocean', 'color': '3700B3', 'textColor': 'white'},
    {'name': 'Midnight', 'color': '191970', 'textColor': 'white'},
    {'name': 'Obsidian', 'color': '000000', 'textColor': 'white'},
    // mid-dark
    {'name': 'Charcoal', 'color': '333333', 'textColor': 'white'},
    {'name': 'Graphite', 'color': '424242', 'textColor': 'white'},
    {'name': 'Slate', 'color': '4A5568', 'textColor': 'white'},
    {'name': 'Olive', 'color': '808000', 'textColor': 'white'},
    {'name': 'Pine', 'color': '01796F', 'textColor': 'white'},
    {'name': 'Forest', 'color': '228B22', 'textColor': 'white'},
    {'name': 'Steel Blue', 'color': '4682B4', 'textColor': 'white'},
    // semantic
    {
      'name': 'Delete Red',
      'color': deleteRed.value.toRadixString(16),
      'textColor': 'white',
    },
    {
      'name': 'Primary',
      'color': primary.value.toRadixString(16),
      'textColor': 'white',
    },
    //
    {'name': 'Teal', 'color': '03DAC5', 'textColor': 'black'},
    {'name': 'Peacock', 'color': '33A1C9', 'textColor': 'black'},
    {'name': 'Lagoon', 'color': '20B2AA', 'textColor': 'black'},
    {'name': 'Emerald', 'color': '50C878', 'textColor': 'black'},
    {'name': 'Coral', 'color': 'FF7F50', 'textColor': 'black'},
    {'name': 'Amber', 'color': 'FFC107', 'textColor': 'black'},
    {'name': 'Blush', 'color': 'FFB6C1', 'textColor': 'black'},
    {'name': 'Parchment', 'color': 'F1E9D2', 'textColor': 'black'},
    {'name': 'Sunshine', 'color': 'FFFACD', 'textColor': 'black'},
    {'name': 'Pearl', 'color': 'F0F0F0', 'textColor': 'black'},
    {'name': 'Default Light', 'color': 'F5F7FA', 'textColor': 'black'},
    {'name': 'White', 'color': 'FFFFFF', 'textColor': 'black'},
  ];
}
//     {'name': 'Midnight', 'color': '191970'},

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
