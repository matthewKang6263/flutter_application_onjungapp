import 'package:flutter/material.dart';

/// 🔹 친구와의 관계 유형
/// - 친구 등록 시 선택 가능하며, 관계 태그/필터 등에 사용됨
enum RelationType {
  unset, // 관계 미설정 상태 (UI에서는 '미정' 태그로 표시)
  family, // 가족
  relative, // 친척
  friend, // 친구
  acquaintance, // 지인
  coworker, // 직장
  etc, // 기타
}

/// 🔸 RelationType 확장
/// - 각 enum에 대해 UI에 필요한 한글 라벨, 배경색, 텍스트 색상을 정의
extension RelationTypeExtension on RelationType {
  /// 🔹 관계에 대한 한글 라벨
  /// - 태그 등에 표시할 텍스트로 사용됨
  String get label {
    switch (this) {
      case RelationType.family:
        return '가족';
      case RelationType.relative:
        return '친척';
      case RelationType.friend:
        return '친구';
      case RelationType.acquaintance:
        return '지인';
      case RelationType.coworker:
        return '직장';
      case RelationType.etc:
        return '기타';
      case RelationType.unset:
        return '미정';
    }
  }

  /// 🔹 태그 배경색
  Color get backgroundColor {
    switch (this) {
      case RelationType.family:
        return const Color(0xFFFDF3F2);
      case RelationType.relative:
        return const Color(0xFFF1F9EC);
      case RelationType.friend:
        return const Color(0xFFEEF7FC);
      case RelationType.acquaintance:
        return const Color(0xFFF8F3FC);
      case RelationType.coworker:
        return const Color(0xFFEBF9F8);
      case RelationType.etc:
        return const Color(0xFFFFFCE4);
      case RelationType.unset:
        return const Color(0xFFF6F1EE);
    }
  }

  /// 🔹 태그 텍스트 색상
  Color get textColor {
    switch (this) {
      case RelationType.family:
        return const Color(0xFFC9747D);
      case RelationType.relative:
        return const Color(0xFF79C444);
      case RelationType.friend:
        return const Color(0xFF74B0E4);
      case RelationType.acquaintance:
        return const Color(0xFF9F75CA);
      case RelationType.coworker:
        return const Color(0xFF36C3B5);
      case RelationType.etc:
        return const Color(0xFFD5B31E);
      case RelationType.unset:
        return const Color(0xFF988F8C);
    }
  }

  /// ✅ 🔹 문자열을 RelationType으로 변환
  static RelationType fromString(String? value) {
    if (value == null) return RelationType.unset;
    return RelationType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => RelationType.unset,
    );
  }
}
