import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: 'EB Garamond',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle title(BuildContext context) => TextStyle(
    fontFamily: 'EB Garamond',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.onBackground(context),
    letterSpacing: 0.15,
  );

  static TextStyle subtitle(BuildContext context) => TextStyle(
    fontFamily: 'EB Garamond',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.onSurface(context),
    height: 1.5,
  );

  static TextStyle sectionTitle(BuildContext context) => TextStyle(
    fontFamily: 'EB Garamond',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.primary(context),
    letterSpacing: 0.5,
  );

  static TextStyle lawTitle(BuildContext context) => TextStyle(
    fontFamily: 'EB Garamond',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
    color: AppColors.onSurface(context),
    height: 1.4,
  );

  static TextStyle lawReference(BuildContext context) => TextStyle(
    fontFamily: 'EB Garamond',
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurface(context).withValues(alpha: 0.8),
  );

  static TextStyle lawExplanation(BuildContext context) => TextStyle(
    fontFamily: 'EB Garamond',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.onBackground(context),
    height: 1.6,
  );

  static TextStyle optionsCount(BuildContext context) => TextStyle(
    fontFamily: 'EB Garamond',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurface(context).withValues(alpha: 0.6),
  );

  static TextStyle question(BuildContext context) => TextStyle(
    fontFamily: 'EB Garamond',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.onBackground(context),
    height: 1.4,
  );

  static TextStyle answer(BuildContext context) => TextStyle(
    fontFamily: 'EB Garamond',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.onBackground(context),
    height: 1.6,
  );

  static TextStyle buttonText(BuildContext context) => TextStyle(
    fontFamily: 'EB Garamond',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );
}