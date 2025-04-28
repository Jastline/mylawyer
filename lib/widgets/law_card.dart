import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../resources/resources.dart';
import '../models/models.dart';

class LawCard extends StatelessWidget {
  final RusLawDocument document;
  final VoidCallback? onTap;

  const LawCard({required this.document, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: AppColors.cardBackground(context), // Добавляем context сюда
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                document.title,
                style: AppTextStyles.lawTitle(context),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.onSurface(context).withValues(alpha: 0.6), // Добавляем context сюда
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(document.docDate),
                    style: AppTextStyles.lawReference(context),
                  ),
                  const Spacer(),
                  Text(
                    document.docNumber,
                    style: AppTextStyles.lawReference(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd.MM.yyyy').format(parsed);
    } catch (e) {
      return date;
    }
  }
}
