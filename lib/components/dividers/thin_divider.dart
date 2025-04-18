// 📁 lib/components/dividers/thin_divider.dart
import 'package:flutter/material.dart';

/// 얇은 회색 줄 Divider 컴포넌트
/// - 색상: #E9E5E1
/// - 높이: 1
/// - 기본적으로 좌우 마진 16 적용
/// - [hasMargin]을 false로 설정하면 마진 없이 전체 폭 사용 가능
class ThinDivider extends StatelessWidget {
  final bool hasMargin;

  const ThinDivider({super.key, this.hasMargin = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: hasMargin
          ? const EdgeInsets.symmetric(horizontal: 16)
          : EdgeInsets.zero,
      height: 1,
      color: const Color(0xFFE9E5E1),
    );
  }
}
