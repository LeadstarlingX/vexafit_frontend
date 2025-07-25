import 'package:flutter/material.dart';

class AppTheme {
  // Private constructor
  AppTheme._();

  static final ThemeData darkTheme = ThemeData(
    // --- Colors ---
    scaffoldBackgroundColor: const Color(0xFF121212), // A dark, charcoal background
    primaryColor: const Color(0xFFBB86FC), // A vibrant purple for primary elements
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFBB86FC),      // Main actions, buttons, highlights
      secondary: Color(0xFF03DAC6),     // Accent color for FABs, toggles
      surface: Color(0xFF1E1E1E),      // Surface color for cards, dialogs
      background: Color(0xFF121212),   // Overall background
      error: Color(0xFFCF6679),        // For error messages and icons
      onPrimary: Colors.black,         // Text/icons on primary color
      onSecondary: Colors.black,       // Text/icons on secondary color
      onSurface: Colors.white,         // Text/icons on surface color
      onBackground: Colors.white,      // Text/icons on background color
      onError: Colors.black,           // Text/icons on error color
    ),

    // --- Typography ---
    fontFamily: 'Inter', // Using a clean, modern font like Inter is a good choice
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.bold, color: Colors.white),
      displayMedium: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold, color: Colors.white),
      displaySmall: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.white),

      headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w700, color: Colors.white),
      headlineMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700, color: Colors.white),
      headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color: Colors.white),

      titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.white),
      titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.white),
      titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.white),

      bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.white70),
      bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white70),
      bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.white70),

      labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Color(0xFFBB86FC)),
      labelMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Color(0xFFBB86FC)),
      labelSmall: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold, color: Color(0xFFBB86FC)),
    ),

    // --- Button Themes ---
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black, // Text color on the button
        backgroundColor: const Color(0xFFBB86FC), // Background color of the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    // --- Card Theme ---
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E), // Surface color
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),

    // --- AppBar Theme ---
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E), // A slightly lighter dark for contrast
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    ),

    // --- Input Decoration Theme (for TextFields) ---
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFBB86FC), width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.white70),
    ),
  );
}