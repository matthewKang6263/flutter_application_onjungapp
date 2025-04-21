// lib/components/dividers/thin_divider.dart

import 'package:flutter/material.dart';

/// 🔹 얇은 회색 줄 Divider
/// - 기본 좌우 마진 16, 높이 1
/// - hasMargin=false 시 마진 제거
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
