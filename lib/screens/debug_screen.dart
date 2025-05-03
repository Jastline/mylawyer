import 'package:flutter/material.dart';
import '../services/db_helper.dart';

class DebugScreen extends StatelessWidget {
  final DBHelper dbHelper;

  const DebugScreen({required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text('Documents: ${snapshot.data}');
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<int> _loadData() async {
    final db = await dbHelper.database;
    final count = await db.rawQuery('SELECT COUNT(*) FROM rus_law_document');
    return count.first['COUNT(*)'] as int;
  }
}