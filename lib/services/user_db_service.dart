import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_profile.dart';

class UserDatabaseService {
  static final UserDatabaseService _instance = UserDatabaseService._internal();

  static UserDatabaseService get instance => _instance;

  factory UserDatabaseService() => _instance;

  UserDatabaseService._internal();

  Database? _database;

  Future<void> init() async {
    if (_database != null) return;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'user_profile.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user_profile (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            avatarPath TEXT,
            totalLawsRead INTEGER,
            lawsByCategory TEXT,
            timeSpent TEXT,
            lightTheme INTEGER
          );
        ''');

        await db.insert('user_profile', {
          'name': 'User',
          'avatarPath': '',
          'totalLawsRead': 0,
          'lawsByCategory': '',
          'timeSpent': '00:00',
          'lightTheme': 1,
        });
      },
    );
  }

  Future<bool> getUserTheme() async {
    final db = _database!;
    final result = await db.query('user_profile', limit: 1);
    return (result.first['lightTheme'] as int) == 1;
  }

  Future<void> updateUserTheme(bool isLightTheme) async {
    final db = _database!;
    await db.update(
      'user_profile',
      {'lightTheme': isLightTheme ? 1 : 0},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  Future<UserProfile?> getUserProfile() async {
    final db = _database!;
    final result = await db.query('user_profile', limit: 1);
    if (result.isNotEmpty) {
      return UserProfile.fromMap(result.first);
    }
    return null;
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    final db = _database!;
    await db.update(
      'user_profile',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }
}
