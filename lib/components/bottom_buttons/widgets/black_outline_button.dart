// lib/components/bottom_buttons/widgets/black_outline_button.dart

import 'package:flutter/material.dart';

/// 🔹 검정 테두리 + 투명 배경 버튼
/// - [text]: 버튼 텍스트
/// - [onTap]: 탭 콜백
class BlackOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const BlackOutlineButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xFF2A2928), width: 1),
            borderRadius: BorderRadius.circular(1000),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF2A2928),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Pretendard',
          ),
        ),
      ),
    );
  }
}
