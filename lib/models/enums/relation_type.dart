// lib/models/enums/relation_type.dart

import 'package:flutter/material.dart';

/// 🔹 친구와의 관계 유형
enum RelationType {
  unset, // 미정
  family, // 가족
  relative, // 친척
  friend, // 친구
  acquaintance, // 지인
  coworker, // 직장
  etc, // 기타
}

/// 🔸 RelationType 확장: UI 표시용 한글 라벨 및 색상 설정
extension RelationTypeExtension on RelationType {
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

  /// 🔹 문자열 → RelationType 변환 (디폴트 unset)
  static RelationType fromString(String? value) {
    if (value == null) return RelationType.unset;
    return RelationType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => RelationType.unset,
    );
  }
}
