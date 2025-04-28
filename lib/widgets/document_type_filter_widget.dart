import 'package:flutter/material.dart';

class DocumentTypeFilterWidget extends StatelessWidget {
  final String? selectedDocType;
  final List<String> docTypes;
  final Function(String?) onDocTypeChanged;

  const DocumentTypeFilterWidget({
    Key? key,
    required this.selectedDocType,
    required this.docTypes,
    required this.onDocTypeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedDocType,
      onChanged: onDocTypeChanged,
      items: docTypes.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
