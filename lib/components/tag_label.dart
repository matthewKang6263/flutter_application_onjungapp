// 📁 파일 경로: components/tag_label.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';

/// 🔹 공통 태그 라벨 위젯
/// - 관계(RelationType) 기반의 태그 스타일을 시각적으로 구성
class TagLabel extends StatelessWidget {
  final String label; // 태그에 표시할 텍스트
  final Color backgroundColor; // 태그 배경색
  final Color textColor; // 태그 텍스트 색상

  const TagLabel({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), // 내부 여백
      decoration: ShapeDecoration(
        color: backgroundColor, // 배경색 적용
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000), // pill 모양
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Pretendard',
          color: textColor, // 텍스트 색상 적용
        ),
      ),
    );
  }

  /// ✅ RelationType 기반 태그 위젯 생성
  /// - enum을 넘기면 label/배경색/글자색 자동 지정
  static Widget fromRelationType(RelationType type) {
    return TagLabel(
      label:
          type == RelationType.unset ? '미정' : type.label, // 'unset'은 '미정'으로 표시
      backgroundColor: type.backgroundColor,
      textColor: type.textColor,
    );
  }
}
