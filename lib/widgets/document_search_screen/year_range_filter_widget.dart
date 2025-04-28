import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart'; // Используем flutter_xlider
import '../../resources/resources.dart'; // Подключаем AppTextStyles

class YearRangeFilterWidget extends StatelessWidget {
  final RangeValues selectedYearRange;
  final Function(RangeValues) onYearRangeChanged;
  final int minYear;
  final int maxYear;

  const YearRangeFilterWidget({
    Key? key,
    required this.selectedYearRange,
    required this.onYearRangeChanged,
    required this.minYear,
    required this.maxYear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FlutterSlider(
          min: minYear.toDouble(),
          max: maxYear.toDouble(),
          values: [selectedYearRange.start, selectedYearRange.end],
          onDragging: (_, lower, upper) => onYearRangeChanged(RangeValues(lower, upper)),
          handler: FlutterSliderHandler(
            child: Icon(Icons.circle, size: 18),
          ),
          tooltip: FlutterSliderTooltip(
            alwaysShowTooltip: true,
            custom: (value) => Text(value.toInt().toString()),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Диапазон: ${selectedYearRange.start.toInt()} - ${selectedYearRange.end.toInt()}',
          style: AppTextStyles.subtitle(context),
        ),
      ],
    );
  }
}