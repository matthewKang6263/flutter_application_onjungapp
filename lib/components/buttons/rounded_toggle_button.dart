// lib/components/buttons/rounded_toggle_button.dart

import 'package:flutter/material.dart';

/// 🔹 양쪽 토글 버튼
/// - [isLeftSelected]에 따라 색상 전환
class RoundedToggleButton extends StatelessWidget {
  final String leftText;
  final String rightText;
  final bool isLeftSelected;
  final ValueChanged<bool> onToggle;

  const RoundedToggleButton({
    super.key,
    required this.leftText,
    required this.rightText,
    required this.isLeftSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: const Color(0xFFE9E5E1),
          borderRadius: BorderRadius.circular(1000)),
      child: Row(children: [
        // 왼쪽
        Expanded(
          child: GestureDetector(
            onTap: () => onToggle(true),
            child: Container(
              decoration: BoxDecoration(
                color: isLeftSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(1000),
              ),
              alignment: Alignment.center,
              child: Text(leftText,
                  style: TextStyle(
                      color: isLeftSelected
                          ? const Color(0xFF2A2928)
                          : const Color(0xFFB5B1AA),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Pretendard')),
            ),
          ),
        ),
        // 오른쪽
        Expanded(
          child: GestureDetector(
            onTap: () => onToggle(false),
            child: Container(
              decoration: BoxDecoration(
                color: isLeftSelected ? Colors.transparent : Colors.white,
                borderRadius: BorderRadius.circular(1000),
              ),
              alignment: Alignment.center,
              child: Text(rightText,
                  style: TextStyle(
                      color: isLeftSelected
                          ? const Color(0xFFB5B1AA)
                          : const Color(0xFF2A2928),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Pretendard')),
            ),
          ),
        ),
      ]),
    );
  }
}
