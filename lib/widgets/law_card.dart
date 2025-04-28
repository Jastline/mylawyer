import '../resources/resources.dart';
import '../models/models.dart';
import 'package:flutter/material.dart';

class LawCard extends StatelessWidget {
  final RusLawDocument document;
  final VoidCallback? onTap;

  const LawCard({required this.document, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: AppColors.cardBackground(context),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                document.title,
                style: AppTextStyles.lawTitle(context),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.onSurface(context).withOpacity(0.6),
                  ),
                  SizedBox(width: 4),
                  Text(
                    _formatDate(document.docDate),
                    style: AppTextStyles.lawReference(context),
                  ),
                  Spacer(),
                  if (document.docNumber != null)
                    Text(
                      document.docNumber!,
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