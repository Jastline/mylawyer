import 'package:flutter/material.dart';

class AppTheme {
  static const _fontFamily = 'EB Garamond';
  static final _borderRadius = BorderRadius.circular(8);

  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF1976D2),
      primaryContainer: Color(0xFF0D47A1),
      secondary: Color(0xFF42A5F5),
      surface: Colors.white,
      surfaceContainerHighest: Color(0xFFF5F7FA),
      onSurface: Color(0xFF424242),
      onSurfaceVariant: Color(0xFF263238),
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      error: Color(0xFFD32F2F),
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1976D2),
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFE0E5EC),
      selectedColor: const Color(0xFF1976D2),
      disabledColor: Colors.grey,
      labelStyle: const TextStyle(
        color: Colors.black87,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
      ),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: _borderRadius,
      ),
      side: BorderSide.none,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1C2D4A),
      ),
      bodyLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        color: Color(0xFF424242),
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        color: Color(0xFF424242),
        height: 1.6,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1976D2),
        shape: RoundedRectangleBorder(
          borderRadius: _borderRadius,
        ),
        textStyle: const TextStyle(
          fontFamily: _fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF42A5F5),
      primaryContainer: Color(0xFF1976D2),
      secondary: Color(0xFF64B5F6),
      surface: Color(0xFF1E1E2E),
      surfaceContainerHighest: Color(0xFF121212),
      onSurface: Color(0xFFE0E0E0),
      onSurfaceVariant: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      error: Color(0xFFCF6679),
      onError: Colors.black,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color(0xFF1E1E2E),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E2E),
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF2D2D3D),
      selectedColor: const Color(0xFF42A5F5),
      disabledColor: Colors.grey,
      labelStyle: TextStyle(
        color: Colors.white.withValues(alpha: 0.87),
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
      ),
      secondaryLabelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.87)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: _borderRadius,
      ),
      side: BorderSide.none,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        color: Colors.white,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        color: Colors.white,
        height: 1.6,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF42A5F5),
        shape: RoundedRectangleBorder(
          borderRadius: _borderRadius,
        ),
        textStyle: const TextStyle(
          fontFamily: _fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}