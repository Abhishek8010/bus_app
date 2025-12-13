import 'package:flutter/material.dart';

class AppTheme {
  // PROFESSIONAL COLOR PALETTE
  static const Color primary = Color(0xFFEB8C00); // Deep professional orange
  static const Color primaryDark = Color(0xFFCC7700);
  static const Color secondary = Color(0xFFFFC857); // Soft amber
  static const Color background = Color(0xFFF9F9F9); // Clean subtle grey
  static const Color surface = Colors.white;

  // TEXT COLORS
  static const Color textDark = Color(0xFF1F1F1F);
  static const Color textMedium = Color(0xFF4A4A4A);
  static const Color textLight = Color(0xFF7A7A7A);

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: background,

      // -------------------------------------------------
      // 🌟 PROFESSIONAL COLOR SCHEME
      // -------------------------------------------------
      colorScheme: base.colorScheme.copyWith(
        primary: primary,
        secondary: secondary,
        surface: surface,
        background: background,
        brightness: Brightness.light,
      ),

      // -------------------------------------------------
      // 🌟 PROFESSIONAL APP BAR (FLAT, MODERN)
      // -------------------------------------------------
      appBarTheme: const AppBarTheme(
        elevation: 10,
        centerTitle: true,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.amberAccent,
        foregroundColor: textDark,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          color: textDark,
        ),
      ),

      // -------------------------------------------------
      // 🌟 CLEAN PROFESSIONAL TYPOGRAPHY
      // -------------------------------------------------
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: textDark,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: textDark,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: textDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          letterSpacing: 0.3,
          color: textMedium,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          letterSpacing: 0.2,
          color: textMedium,
        ),
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // -------------------------------------------------
      // 🌟 PROFESSIONAL INPUT DECORATION
      // -------------------------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

        // Clean thin border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD0D0D0), width: 1),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primary, width: 1.8),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red.shade700, width: 1.2),
        ),

        labelStyle: const TextStyle(color: textMedium, fontSize: 14),
        hintStyle: const TextStyle(color: textLight, fontSize: 14),
      ),

      // -------------------------------------------------
      // 🌟 PROFESSIONAL BUTTON STYLE (MODERN, M3)
      // -------------------------------------------------
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      // -------------------------------------------------
      // 🌟 PROFESSIONAL CARD THEME (FLAT DESIGN)
      // -------------------------------------------------
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // -------------------------------------------------
      // 🌟 ICON THEME (SUBTLE, NOT CARTOONISH)
      // -------------------------------------------------
      iconTheme: const IconThemeData(
        color: primaryDark,
        size: 24,
      ),
    );
  }
}
