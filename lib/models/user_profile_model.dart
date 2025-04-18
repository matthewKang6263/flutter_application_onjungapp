class UserProfile {
  final String uid;
  final String name;
  final String? phone;
  final String? email;
  final DateTime createdAt;

  UserProfile({
    required this.uid,
    required this.name,
    this.phone,
    this.email,
    required this.createdAt,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
        uid: map['uid'],
        name: map['name'],
        phone: map['phone'],
        email: map['email'],
        createdAt: DateTime.parse(map['createdAt']),
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'phone': phone,
        'email': email,
        'createdAt': createdAt.toIso8601String(),
      };
}
