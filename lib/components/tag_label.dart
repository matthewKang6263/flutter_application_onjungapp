// lib/components/tag_label.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';

/// 🔹 태그 라벨 위젯 (pill 모양)
/// - [label], [backgroundColor], [textColor] 직접 지정
class TagLabel extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const TagLabel({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1000))),
      child: Text(label,
          style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Pretendard')),
    );
  }

  /// 🔸 RelationType 기반 생성
  static Widget fromRelationType(RelationType type) => TagLabel(
        label: type == RelationType.unset ? '미정' : type.label,
        backgroundColor: type.backgroundColor,
        textColor: type.textColor,
      );
}
