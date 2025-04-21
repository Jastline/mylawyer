import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: 'EB Garamond',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle title = TextStyle(
    fontFamily: 'EB Garamond',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: 'EB Garamond',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle question = TextStyle(
    fontFamily: 'EB Garamond',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle answer = TextStyle(
    fontFamily: 'EB Garamond',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'EB Garamond',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    letterSpacing: 0.5,
  );

  static const TextStyle lawTitle = TextStyle(
    fontFamily: 'EB Garamond',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
    color: AppColors.lawText,
  );

  static const TextStyle lawReference = TextStyle(
    fontFamily: 'EB Garamond',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.lawText,
  );

  static const TextStyle lawExplanation = TextStyle(
    fontFamily: 'EB Garamond',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle optionsCount = TextStyle(
    fontFamily: 'EB Garamond',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
}