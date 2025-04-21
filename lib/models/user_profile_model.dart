// lib/models/user_profile_model.dart

/// 🔹 사용자 프로필 모델
/// - 앱에 로그인한 사용자의 기본 정보(uid, 이름, 연락처, 이메일 등)를 관리
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

  /// 📥 Firestore에서 받아온 Map을 UserProfile 객체로 변환
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String?,
      email: map['email'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  /// 📤 UserProfile 객체를 Firestore에 저장 가능한 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// 🔧 일부 필드만 변경하고 나머지는 그대로 복사하여 새 객체 반환
  UserProfile copyWith({
    String? name,
    String? phone,
    String? email,
    DateTime? createdAt,
  }) {
    return UserProfile(
      uid: uid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
