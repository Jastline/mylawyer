import 'package:flutter/material.dart';

class DocumentTypeFilterWidget extends StatefulWidget {
  final List<String> selectedDocTypes;
  final List<String> docTypes;
  final Function(List<String>) onDocTypesChanged;

  const DocumentTypeFilterWidget({
    Key? key,
    required this.selectedDocTypes,
    required this.docTypes,
    required this.onDocTypesChanged,
  }) : super(key: key);

  @override
  _DocumentTypeFilterWidgetState createState() => _DocumentTypeFilterWidgetState();
}

class _DocumentTypeFilterWidgetState extends State<DocumentTypeFilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.docTypes.map((type) {
        return FilterChip(
          label: Text(type),
          selected: widget.selectedDocTypes.contains(type),
          onSelected: (selected) {
            final newSelection = List<String>.from(widget.selectedDocTypes);
            if (selected) {
              newSelection.add(type);
            } else {
              newSelection.remove(type);
            }
            widget.onDocTypesChanged(newSelection);
          },
        );
      }).toList(),
    );
  }
}
