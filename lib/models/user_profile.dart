import 'package:flutter/material.dart';
import 'dart:convert';

class UserProfile {
  final String id;
  String name;
  String? avatarPath;
  int totalLawsRead;
  int testsCompleted;
  Map<String, int> lawsByCategory;
  Map<String, int> timeSpent;
  List<Achievement> achievements;

  UserProfile({
    required this.id,
    required this.name,
    this.avatarPath,
    this.totalLawsRead = 0,
    this.testsCompleted = 0,
    Map<String, int>? lawsByCategory,
    Map<String, int>? timeSpent,
    List<Achievement>? achievements,
  })  : lawsByCategory = lawsByCategory ?? {},
        timeSpent = timeSpent ?? {},
        achievements = achievements ?? [];

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      name: map['name'],
      avatarPath: map['avatarPath'],
      totalLawsRead: map['totalLawsRead'] ?? 0,
      testsCompleted: map['testsCompleted'] ?? 0,
      lawsByCategory: _parseMap(map['lawsByCategory']),
      timeSpent: _parseMap(map['timeSpent']),
      achievements: _parseAchievements(map['achievements']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatarPath': avatarPath,
      'totalLawsRead': totalLawsRead,
      'testsCompleted': testsCompleted,
      'lawsByCategory': _encodeMap(lawsByCategory),
      'timeSpent': _encodeMap(timeSpent),
      'achievements': _encodeAchievements(achievements),
    };
  }

  static Map<String, int> _parseMap(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return {};
    final decoded = json.decode(jsonStr) as Map<String, dynamic>;
    return decoded.map((key, value) => MapEntry(key, value as int));
  }

  static String _encodeMap(Map<String, int> map) {
    return json.encode(map);
  }

  static List<Achievement> _parseAchievements(String? jsonStr) {
    if (jsonStr == null || jsonStr.isEmpty) return [];
    final List<dynamic> decoded = json.decode(jsonStr);
    return decoded.map((e) => Achievement.fromJson(e)).toList();
  }

  static String _encodeAchievements(List<Achievement> achievements) {
    return json.encode(achievements.map((a) => a.toJson()).toList());
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon.codePoint,
    };
  }
}
