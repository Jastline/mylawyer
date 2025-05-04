import 'package:flutter/material.dart';

class AppSnackBar {
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

  static Future<void> showLicenseAgreement({
    required BuildContext context,
    required VoidCallback onAccept,
  }) async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconColor = isDark ? Colors.lightBlue : Colors.blue;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок с переносом текста
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.verified_user, size: 28, color: iconColor),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          'Лицензионное соглашение',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Используя это приложение, вы соглашаетесь с условиями:',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                _buildAgreementPoint(
                  Icons.gavel,
                  'Мы не несем ответственности за точность информации',
                  iconColor,
                ),
                _buildAgreementPoint(
                  Icons.medical_services,
                  'Приложение не заменяет профессиональную консультацию',
                  iconColor,
                ),
                _buildAgreementPoint(
                  Icons.warning,
                  'Все данные предоставляются "как есть" без гарантий',
                  iconColor,
                ),
                _buildAgreementPoint(
                  Icons.security,
                  'Вы используете приложение на свой страх и риск',
                  iconColor,
                ),
                const SizedBox(height: 24),
                // Кнопка (оставляем как было)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: iconColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      shadowColor: iconColor.withValues(alpha: 0.4),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onAccept();
                    },
                    child: const Text(
                      'ПРИНИМАЮ УСЛОВИЯ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildAgreementPoint(IconData icon, String text, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void _showSnackBar(
      BuildContext context,
      String message,
      Color backgroundColor,
      IconData iconData, {
        required Duration duration,
        String actionLabel = 'OK',
      }) {
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
              child: Text(message, style: const TextStyle(color: Colors.white)),
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