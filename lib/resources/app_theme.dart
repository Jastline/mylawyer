import 'package:flutter/material.dart';

class AppTheme {
  static TextTheme _buildTextTheme(Color textColor) {
    return TextTheme(
      displayLarge: const TextStyle(
        fontFamily: 'EB Garamond',
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
      ),
      displayMedium: const TextStyle(
        fontFamily: 'EB Garamond',
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
      titleLarge: const TextStyle(
        fontFamily: 'EB Garamond',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      titleMedium: const TextStyle(
        fontFamily: 'EB Garamond',
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
      bodyLarge: const TextStyle(
        fontFamily: 'EB Garamond',
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.black87,
      ),
      bodyMedium: const TextStyle(
        fontFamily: 'EB Garamond',
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: Colors.black87,
      ),
      labelLarge: const TextStyle(
        fontFamily: 'EB Garamond',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  static final lightTheme = ThemeData(
    primaryColor: const Color(0xFF1A237E),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF1A237E),
      secondary: Color(0xFF303F9F),
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    textTheme: _buildTextTheme(Colors.black87),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A237E),
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'EB Garamond',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: const Color(0xFF1A237E),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF7986CB),
      secondary: Color(0xFF5C6BC0),
      surface: Color(0xFF121212),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: _buildTextTheme(Colors.white70),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A237E),
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'EB Garamond',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: Color(0xFF1E1E1E),
    ),
  );
}