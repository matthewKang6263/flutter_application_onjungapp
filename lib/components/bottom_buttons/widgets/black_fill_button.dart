// lib/components/bottom_buttons/widgets/black_fill_button.dart

import 'package:flutter/material.dart';

/// 🔹 검정 배경 + 흰 텍스트 버튼
/// - [text]: 버튼 텍스트
/// - [icon]: 텍스트 우측 아이콘
/// - [onTap]: 탭 콜백
class BlackFillButton extends StatelessWidget {
  final String text;
  final Widget? icon;
  final VoidCallback onTap;

  const BlackFillButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: ShapeDecoration(
          color: const Color(0xFF2A2928),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Pretendard',
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 6),
              icon!,
            ],
          ],
        ),
      ),
    );
  }
}
