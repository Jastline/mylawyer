import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../data/db_helper.dart';

class ProfileService with ChangeNotifier {
  UserProfile _profile;
  final DBHelper _dbHelper;

  ProfileService(this._dbHelper)
      : _profile = UserProfile(id: '1', name: 'Гость');

  UserProfile get profile => _profile;

  Future<void> loadProfile() async {
    final loadedProfile = await _dbHelper.getProfile();
    if (loadedProfile != null) {
      _profile = loadedProfile;
    }
    notifyListeners();
  }

  Future<void> updateName(String newName) async {
    _profile.name = newName;
    await _dbHelper.saveProfile(_profile);
    notifyListeners();
  }

  Future<void> updateAvatar(String? path) async {
    _profile.avatarPath = path;
    await _dbHelper.saveProfile(_profile);
    notifyListeners();
  }

  Future<void> addLawRead(String category, int readingTime) async {
    _profile.totalLawsRead++;
    _profile.lawsByCategory.update(
      category,
          (value) => value + 1,
      ifAbsent: () => 1,
    );
    _profile.timeSpent.update(
      category,
          (value) => value + readingTime,
      ifAbsent: () => readingTime,
    );
    await _dbHelper.saveProfile(_profile);
    notifyListeners();
  }
}