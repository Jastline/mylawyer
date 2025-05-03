// widgets/app_snackbar.dart
import 'package:flutter/material.dart';

class AppSnackBar {
  // Методы для показа уведомлений остаются без изменений
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      Colors.green,
      Icons.check_circle,
      duration: const Duration(seconds: 3),
    );
  }

  static void showError(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      Colors.red,
      Icons.error,
      duration: const Duration(seconds: 5),
    );
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      Colors.blue,
      Icons.info,
      duration: const Duration(seconds: 3),
    );
  }

  static void showQuickInfo(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      Colors.grey[800]!,
      Icons.info_outline,
      duration: const Duration(seconds: 3),
    );
  }

  static void showLicenseAgreement(BuildContext context, {VoidCallback? onAccept}) {
    final snackBar = SnackBar(
      backgroundColor: Colors.blueGrey,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber, color: Colors.white),
              const SizedBox(width: 8),
              const Text(
                'Лицензионное соглашение',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Используя это приложение, вы соглашаетесь с тем, что:\n'
                '1. Мы не несем ответственности за точность информации\n'
                '2. Приложение не заменяет профессиональную юридическую консультацию\n'
                '3. Все данные предоставляются "как есть" без гарантий\n'
                '4. Вы используете приложение на свой страх и риск\n'
                '5. ДАШКА = КАКАША :)',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blueGrey,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                onAccept?.call();
              },
              child: const Text('Принимаю'),
            ),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      duration: const Duration(days: 1),
      padding: const EdgeInsets.all(16),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void _showSnackBar(
      BuildContext context,
      String message,
      Color backgroundColor,
      IconData iconData, {
        required Duration duration,
        String actionLabel = 'OK',
      }) {
    // Проверяем, что контекст все еще валиден
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Row(
          children: [
            Icon(iconData, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: duration,
        action: SnackBarAction(
          label: actionLabel,
          textColor: Colors.white,
          onPressed: () {
            if (context.mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }
          },
        ),
      ),
    );
  }
}