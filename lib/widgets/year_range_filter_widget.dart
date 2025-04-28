import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart'; // Используем flutter_xlider
import '../resources/resources.dart'; // Подключаем AppTextStyles

class YearRangeFilterWidget extends StatelessWidget {
  final RangeValues selectedYearRange;
  final Function(RangeValues) onYearRangeChanged;

  const YearRangeFilterWidget({
    Key? key,
    required this.selectedYearRange,
    required this.onYearRangeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FlutterSlider(
          min: 1900,
          max: 2023,
          values: [selectedYearRange.start, selectedYearRange.end],
          onDragging: (handlerIndex, lowerValue, upperValue) {
            onYearRangeChanged(RangeValues(lowerValue, upperValue));
          },
          handler: FlutterSliderHandler(
            child: Icon(Icons.circle),
          ),
          trackBar: FlutterSliderTrackBar(
            activeTrackBarHeight: 3,
            inactiveTrackBarHeight: 3,
            activeTrackBar: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5),
            ),
            inactiveTrackBar: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          tooltip: FlutterSliderTooltip(
            alwaysShowTooltip: true,
            custom: (value) => Text(value.toInt().toString()),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Диапазон: ${selectedYearRange.start.toInt()} - ${selectedYearRange.end.toInt()}',
          style: AppTextStyles.subtitle(context), // Используем собственный стиль
        ),
      ],
    );
  }
}
