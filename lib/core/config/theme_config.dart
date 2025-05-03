import 'package:flutter/material.dart';

class AppTheme {
  static const Color maroon = Color(0xFF800000);
  static const Color gold = Color(0xFFFFD700);

  static ThemeData get theme => ThemeData(
        primaryColor: maroon,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: maroon,
          secondary: gold,
          surface: Colors.white,
          background: Colors.grey[50]!,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: maroon,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: maroon,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: maroon, width: 2),
          ),
          labelStyle: const TextStyle(color: maroon),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: maroon,
          unselectedItemColor: Colors.grey,
        ),
      );
}
