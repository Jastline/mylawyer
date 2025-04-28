import 'package:flutter/material.dart';

class AppColors {
  // Основные цвета
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color primaryBlueDark = Color(0xFF0D47A1);
  static const Color secondaryBlue = Color(0xFF42A5F5);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color darkBlue = Color(0xFF1C2D4A);

  // Для светлой темы
  static Color primaryBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFFFFFFF)
        : const Color(0xFF121212);
  }

  static Color surfaceBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFF5F7FA)
        : const Color(0xFF1E1E2E);
  }

  static Color avatarBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFE0E5EC)
        : const Color(0xFF2D2D3D);
  }

  static Color onSurface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFF424242)
        : const Color(0xFFE0E0E0);
  }

  static Color onBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFF263238)
        : const Color(0xFFFFFFFF);
  }

  static Color primary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? primaryBlue
        : secondaryBlue;
  }

  static Color selectedFilterBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightBlue
        : const Color(0xFF2D3A5A);
  }

  static Color unselectedFilterBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFE0E5EC)
        : const Color(0xFF2D2D3D);
  }

  static Color iconColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? primaryBlue
        : secondaryBlue;
  }

  static Color cardBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFFFFFFF)
        : const Color(0xFF1E1E2E);
  }

  static Color errorColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFFD32F2F)
        : const Color(0xFFCF6679);
  }

  static Color successColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? const Color(0xFF388E3C)
        : const Color(0xFF81C784);
  }
}
