// lib/components/bottom_buttons/widgets/disabled_button.dart

import 'package:flutter/material.dart';

/// 🔹 비활성화된 버튼
/// - 클릭 불가, 회색 배경 + 흐린 텍스트
class DisabledButton extends StatelessWidget {
  final String text;

  const DisabledButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: ShapeDecoration(
        color: const Color(0xFFE9E5E1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFFB5B1AA),
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: 'Pretendard',
        ),
      ),
    );
  }
}
