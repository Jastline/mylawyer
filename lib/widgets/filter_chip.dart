import '../resources/resources.dart';
import 'package:flutter/material.dart';


class LawFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const LawFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontFamily: 'EB Garamond',
          color: selected ? Colors.white : AppColors.onSurface(context),
        ),
      ),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: AppColors.unselectedFilterBackground(context),
      selectedColor: AppColors.selectedFilterBackground(context),
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}