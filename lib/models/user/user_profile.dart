class UserProfile {
  final int id;
  final String name;
  final int totalLawsRead;
  final String lawsByCategory;
  final String timeSpent;
  final bool lightTheme;

  UserProfile({
    required this.id,
    required this.name,
    required this.totalLawsRead,
    required this.lawsByCategory,
    required this.timeSpent,
    required this.lightTheme,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['ID'],
      name: map['name'],
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
      'totalLawsRead': totalLawsRead,
      'lawsByCategory': lawsByCategory,
      'timeSpent': timeSpent,
      'lightTheme': lightTheme ? 1 : 0,
    };
  }
}