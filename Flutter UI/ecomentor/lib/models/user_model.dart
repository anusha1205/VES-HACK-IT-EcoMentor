class UserModel {
  final String uid;
  final String email;
  final String name;
  String? photoUrl;
  int points;
  List<String> completedCourses;
  List<String> inProgressCourses;
  List<String> badges;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl,
    this.points = 0,
    List<String>? completedCourses,
    List<String>? inProgressCourses,
    List<String>? badges,
  })  : completedCourses = completedCourses ?? [],
        inProgressCourses = inProgressCourses ?? [],
        badges = badges ?? [];

  // Create from Firebase User
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'],
      points: map['points'] ?? 0,
      completedCourses: List<String>.from(map['completedCourses'] ?? []),
      inProgressCourses: List<String>.from(map['inProgressCourses'] ?? []),
      badges: List<String>.from(map['badges'] ?? []),
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'points': points,
      'completedCourses': completedCourses,
      'inProgressCourses': inProgressCourses,
      'badges': badges,
    };
  }

  // Create a copy of the user with updated fields
  UserModel copyWith({
    String? name,
    String? photoUrl,
    int? points,
    List<String>? completedCourses,
    List<String>? inProgressCourses,
    List<String>? badges,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      points: points ?? this.points,
      completedCourses: completedCourses ?? this.completedCourses,
      inProgressCourses: inProgressCourses ?? this.inProgressCourses,
      badges: badges ?? this.badges,
    );
  }
}
