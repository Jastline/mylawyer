class UserProfile {
  final int id;
  final String name;
  final String avatarPath;
  final int totalLawsRead;
  final String lawsByCategory;
  final String timeSpent;
  final bool lightTheme;

  UserProfile({
    required this.id,
    required this.name,
    required this.avatarPath,
    required this.totalLawsRead,
    required this.lawsByCategory,
    required this.timeSpent,
    required this.lightTheme,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['ID'],
      name: map['name'],
      avatarPath: map['avatarPath'] = "assets/images/default_avatar.png",
      totalLawsRead: map['totalLawsRead'],
      lawsByCategory: map['lawsByCategory'],
      timeSpent: map['timeSpent'],
      lightTheme: map['lightTheme'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ID': id,
      'name': name,
      'avatarPath': avatarPath,
      'totalLawsRead': totalLawsRead,
      'lawsByCategory': lawsByCategory,
      'timeSpent': timeSpent,
      'lightTheme': lightTheme ? 1 : 0,
    };
  }
}
