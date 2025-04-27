import '../base/db_model.dart';

class UserProfile implements DbModel {
  @override
  final int id;
  final String name;
  final int totalLawsRead;
  final String? lawsByCategory;
  final String? timeSpent;
  final bool lightTheme;

  UserProfile({
    required this.id,
    required this.name,
    this.totalLawsRead = 0,
    this.lawsByCategory,
    this.timeSpent,
    this.lightTheme = true,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'name': name,
      'totalLawsRead': totalLawsRead,
      'lawsByCategory': lawsByCategory,
      'timeSpent': timeSpent,
      'lightTheme': lightTheme ? 1 : 0,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['ID'] as int,
      name: map['name'] as String,
      totalLawsRead: map['totalLawsRead'] as int? ?? 0,
      lawsByCategory: map['lawsByCategory'] as String?,
      timeSpent: map['timeSpent'] as String?,
      lightTheme: map['lightTheme'] == 1,
    );
  }
}