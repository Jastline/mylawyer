import 'package:flutter/material.dart';

class DatabaseCheckboxItem extends StatefulWidget {
  final String path;
  final bool isSelected;
  final Function(bool?) onChanged;

  const DatabaseCheckboxItem({
    Key? key,
    required this.path,
    required this.isSelected,
    required this.onChanged,
  }) : super(key: key);

  @override
  _DatabaseCheckboxItemState createState() => _DatabaseCheckboxItemState();
}

class _DatabaseCheckboxItemState extends State<DatabaseCheckboxItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: widget.isSelected,
        onChanged: widget.onChanged,
      ),
      title: Text(widget.path.split('/').last),
      subtitle: Text(widget.path),
    );
  }
}