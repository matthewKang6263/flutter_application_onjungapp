// lib/components/buttons/selectable_chip_button.dart

import 'package:flutter/material.dart';

/// 🔹 선택 가능한 칩 버튼
/// - [isSelected], [isEnabled] 상태에 따라 색상 변화
class SelectableChipButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;

  const SelectableChipButton({
    super.key,
    required this.label,
    required this.isSelected,
    this.isEnabled = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    if (isEnabled) {
      bg = isSelected ? const Color(0xFFC9885C) : const Color(0xFFF9F4EE);
      fg = isSelected ? Colors.white : const Color(0xFF2A2928);
    } else {
      bg = isSelected ? const Color(0xFFD9C4B5) : const Color(0xFFF5F3F0);
      fg = isSelected ? Colors.white : const Color(0xFFB5B1AA);
    }

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
        alignment: Alignment.center,
        child: Text(label,
            style: TextStyle(
                color: fg,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Pretendard')),
      ),
    );
  }
}
