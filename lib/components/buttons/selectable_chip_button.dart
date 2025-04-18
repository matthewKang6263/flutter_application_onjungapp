import 'package:flutter/material.dart';

/// 선택 가능한 칩 스타일 버튼 위젯
/// 선택 여부 및 활성화 여부에 따라 배경색, 텍스트 색상이 달라짐
/// [label]은 버튼에 표시할 텍스트
/// [isSelected]는 선택 상태 여부
/// [isEnabled]는 버튼이 활성화 상태인지 여부 (기본값 true)
/// [onTap]은 버튼 클릭 시 실행될 함수
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
    // 🔹 조건에 따라 배경/텍스트 색상 지정
    Color backgroundColor;
    Color textColor;

    if (isEnabled) {
      backgroundColor =
          isSelected ? const Color(0xFFC9885C) : const Color(0xFFF9F4EE);
      textColor = isSelected ? Colors.white : const Color(0xFF2A2928);
    } else {
      if (isSelected) {
        backgroundColor =
            const Color.fromARGB(255, 169, 168, 168); // 선택된 비활성화용 색 (연한 주황)
        textColor =
            const Color.fromARGB(255, 255, 255, 255); // 강조를 위해 텍스트는 진한 회색 유지
      } else {
        backgroundColor = const Color(0xFFF5F3F0); // 일반 비활성화 색
        textColor = const Color(0xFFB5B1AA); // 연한 회색 텍스트
      }
    }

    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
