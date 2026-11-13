import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppPalette {
  // Primary brand colors
  static const Color primary = Color(0xFF635BFF); // Rich violet-blue
  static const Color secondary = Color(0xFF3BC9A7); // Soft teal accent

  // Backgrounds
  static const Color backgroundLight = Color(
    0xFFFDFCFD,
  ); // Very light, soft white
  static const Color backgroundDark = Color(0xFF1D1D28); // Deep dark navy

  // Card surfaces
  static const Color cardLight = Color(0xFFFFFFFF); // Pure white card surface
  static const Color cardDark = Color(0xFF2A2A3D); // Charcoal card surface

  // Text colors for optimal contrast
  static const Color textPrimaryLight = Color(
    0xFF1B1B1B,
  ); // Near black for light mode
  static const Color textSecondaryLight = Color(
    0xFF555555,
  ); // Dark grey for secondary text

  static const Color textPrimaryDark = Color(
    0xFFE3E3E3,
  ); // Soft white for dark mode
  static const Color textSecondaryDark = Color(
    0xFFAAAAAA,
  ); // Light grey for secondary text

  // Accent colors for states and highlights
  static const Color errorRed = Color(0xFFE94F37);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningAmber = Color(0xFFFFB74D);

  // Icon and divider shades
  static const Color iconLight = Color(0xFF7B7B7B);
  static const Color iconDark = Color(0xFF9E9E9E);
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF3E3E4E);

  // Note color options
  static List<Map<String, dynamic>> noteColors = [
    {'name': 'Classic White', 'color': 'FFFFFF', 'textColor': Colors.black},
    {'name': 'Midnight Black', 'color': '1D1D28', 'textColor': Colors.white},
    {'name': 'Peach Cream', 'color': 'FFE4D6', 'textColor': Colors.black87},
    {'name': 'Coral Blush', 'color': 'FF6F61', 'textColor': Colors.white},
    {
      'name': 'Sunflower Yellow',
      'color': 'FFE066',
      'textColor': Colors.black87,
    },
    {'name': 'Mint Whisper', 'color': 'B5EAD7', 'textColor': Colors.black87},
    {'name': 'Sky Breeze', 'color': 'A9DEF9', 'textColor': Colors.black87},
    {'name': 'Lavender Mist', 'color': 'E0BBE4', 'textColor': Colors.black87},
    {'name': 'Slate Grey', 'color': 'B0BEC5', 'textColor': Colors.black87},
  ];
}

class AppTheme {
  // Reusable text theme with Tajawal
  static TextTheme _textTheme(Color primaryText, Color secondaryText) =>
      GoogleFonts.tajawalTextTheme().copyWith(
        headlineLarge: GoogleFonts.tajawal(
          textStyle: TextStyle(
            color: primaryText,
            fontWeight: FontWeight.w700,
            fontSize: 28,
          ),
        ),
        headlineMedium: GoogleFonts.tajawal(
          textStyle: TextStyle(
            color: primaryText,
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        headlineSmall: GoogleFonts.tajawal(
          textStyle: TextStyle(
            color: primaryText,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        titleLarge: GoogleFonts.tajawal(
          textStyle: TextStyle(
            color: primaryText,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        titleMedium: GoogleFonts.tajawal(
          textStyle: TextStyle(
            color: secondaryText,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        bodyLarge: GoogleFonts.tajawal(
          textStyle: TextStyle(
            color: primaryText,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        bodyMedium: GoogleFonts.tajawal(
          textStyle: TextStyle(
            color: secondaryText,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        bodySmall: GoogleFonts.tajawal(
          textStyle: TextStyle(
            color: secondaryText,
            fontWeight: FontWeight.w300,
            fontSize: 12,
          ),
        ),
        labelLarge: GoogleFonts.tajawal(
          textStyle: TextStyle(
            color: primaryText,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        labelMedium: GoogleFonts.tajawal(
          textStyle: TextStyle(
            color: secondaryText,
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
      );

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF9FAFB),
    primaryColor: const Color(0xFF6C63FF),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF6C63FF),
      onPrimary: Colors.white,
      secondary: Color(0xFF3BC9A7),
      onSecondary: Colors.white,
      background: Color(0xFFF9FAFB),
      onBackground: Color(0xFF1B1B1B),
      surface: Colors.white,
      onSurface: Color(0xFF1B1B1B),
      error: Color(0xFFE94F37),
      onError: Colors.white,
      outline: Color(0xFFE0E0E0),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.black54),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: Colors.black87,
      ),
    ),
    cardColor: Colors.white,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: GoogleFonts.tajawal(color: Colors.grey, fontSize: 14),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      modalBackgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    dividerColor: Colors.grey.shade300,
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      contentTextStyle: const TextStyle(color: Colors.black54, fontSize: 15),
    ),
    textTheme: _textTheme(Colors.black87, Colors.black54),
    iconTheme: const IconThemeData(color: Colors.grey),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: GoogleFonts.tajawal(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        elevation: 2,
        shadowColor: Colors.black12,
      ),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: Colors.white,
      iconColor: const Color(0xFF6C63FF),
      textColor: Colors.black87,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      horizontalTitleGap: 12,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(const Color(0xFF6C63FF)),
      trackColor: MaterialStateProperty.all(Colors.grey.shade300),
    ),
    // ✨ NEW: Dropdown & Menu Themes
    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.white),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevation: WidgetStatePropertyAll(4),
        side: WidgetStatePropertyAll(
          const BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      textStyle: GoogleFonts.tajawal(color: Colors.black87, fontSize: 15),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey.shade100,
      selectedColor: const Color(0xFF6C63FF).withOpacity(0.15),
      labelStyle: GoogleFonts.tajawal(color: Colors.black87, fontSize: 13),
      secondaryLabelStyle: GoogleFonts.tajawal(
        color: Colors.grey,
        fontSize: 12,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF1B1B1B),
      contentTextStyle: GoogleFonts.tajawal(color: Colors.white, fontSize: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
    ),
  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF121212),
    primaryColor: const Color(0xFF8A74FF),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF8A74FF),
      onPrimary: Colors.white,
      secondary: Color(0xFF3BC9A7),
      onSecondary: Colors.black87,
      background: Color(0xFF121212),
      onBackground: Color(0xFFE3E3E3),
      surface: Color(0xFF2A2A3D),
      onSurface: Color(0xFFE3E3E3),
      error: Color(0xFFE94F37),
      onError: Colors.white,
      outline: Color(0xFF3E3E4E),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1D1D28),
      foregroundColor: Colors.white,
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.white70),
      titleTextStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
    ),
    cardColor: const Color(0xFF2A2A3D),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2A3D),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF3E3E4E), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF8A74FF), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: GoogleFonts.tajawal(color: Colors.grey[500], fontSize: 14),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFF1D1D28),
      modalBackgroundColor: Color(0xFF1D1D28),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    dividerColor: Colors.grey.shade700,
    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFF2A2A3D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      contentTextStyle: const TextStyle(color: Colors.grey, fontSize: 15),
    ),
    textTheme: _textTheme(Colors.white, Colors.grey[400]!),
    iconTheme: IconThemeData(color: Colors.grey[300]),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8A74FF),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: GoogleFonts.tajawal(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        elevation: 4,
        shadowColor: Colors.black54,
      ),
    ),
    listTileTheme: ListTileThemeData(
      tileColor: const Color(0xFF2A2A3D),
      iconColor: const Color(0xFF3BC9A7),
      textColor: Colors.white,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      horizontalTitleGap: 12,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(const Color(0xFF8A74FF)),
      trackColor: MaterialStateProperty.all(Colors.grey.shade800),
    ),
    // ✨ NEW: Dropdown & Menu Themes (Dark)
    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A3D),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3E3E4E), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF8A74FF), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(const Color(0xFF2A2A3D)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevation: WidgetStatePropertyAll(8),
        side: WidgetStatePropertyAll(
          const BorderSide(color: Color(0xFF3E3E4E)),
        ),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: const Color(0xFF2A2A3D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      textStyle: GoogleFonts.tajawal(color: Colors.white, fontSize: 15),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.grey.shade800,
      selectedColor: const Color(0xFF8A74FF).withOpacity(0.2),
      labelStyle: GoogleFonts.tajawal(color: Colors.white, fontSize: 13),
      secondaryLabelStyle: GoogleFonts.tajawal(
        color: Colors.grey[400],
        fontSize: 12,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF2A2A3D),
      contentTextStyle: GoogleFonts.tajawal(color: Colors.white, fontSize: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
    ),
  );
}

/* import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppPalette {
  static const Color primary = Color.fromARGB(255, 150, 138, 255);
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
    {'name': 'White', 'color': 'FFFFFF', 'textColor': 'black'},
    {'name': 'Black', 'color': '333333', 'textColor': 'white'},
    {"name": "Soft Peach", "color": "FFE4D6"},
    {"name": "Coral", "color": "FF6F61"},
    {"name": "Sunflower", "color": "FFE066"},
    {"name": "Mint Green", "color": "B5EAD7"},
    {"name": "Sky Blue", "color": "A9DEF9"},
    {"name": "Lavender", "color": "E0BBE4"},
    {"name": "Slate Grey", "color": "B0BEC5"},
    // {"name": "Midnight", "color": "191970"},
  ];

  /* [
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
  ]; */
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
    textTheme: GoogleFonts.tajawalTextTheme().copyWith(
      headlineSmall: GoogleFonts.tajawal(
        textStyle: const TextStyle(color: Colors.black87),
      ),
      headlineMedium: GoogleFonts.tajawal(
        textStyle: const TextStyle(color: Colors.black87),
      ),
      headlineLarge: GoogleFonts.tajawal(
        textStyle: const TextStyle(color: Colors.black87),
      ),
      titleLarge: GoogleFonts.tajawal(
        textStyle: const TextStyle(color: Colors.black87),
      ),
      titleMedium: GoogleFonts.tajawal(
        textStyle: const TextStyle(color: Colors.black87),
      ),
      bodyLarge: GoogleFonts.tajawal(
        textStyle: const TextStyle(color: Colors.black),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppPalette.sheetLight,
      modalBackgroundColor: AppPalette.sheetLight,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppPalette.sheetLight,
      titleTextStyle: const TextStyle(color: Colors.black87),
      contentTextStyle: const TextStyle(color: Colors.black54),
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
    textTheme: GoogleFonts.tajawalTextTheme().copyWith(
      headlineSmall: GoogleFonts.tajawal(
        textStyle: const TextStyle(color: Colors.white70),
      ),
      headlineMedium: GoogleFonts.tajawal(
        textStyle: const TextStyle(color: Colors.white),
      ),
      headlineLarge: GoogleFonts.tajawal(
        textStyle: const TextStyle(color: Colors.white),
      ),
      titleLarge: GoogleFonts.tajawal(
        textStyle: const TextStyle(color: Colors.white70),
      ),
      titleMedium: GoogleFonts.tajawal(
        textStyle: const TextStyle(color: Colors.white70),
      ),
      bodyLarge: GoogleFonts.tajawal(
        textStyle: const TextStyle(color: Colors.white),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppPalette.sheetDark,
      modalBackgroundColor: AppPalette.sheetDark,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppPalette.sheetDark,
      titleTextStyle: const TextStyle(color: Colors.white),
      contentTextStyle: const TextStyle(color: Colors.white70),
    ),
  );
}
 */
