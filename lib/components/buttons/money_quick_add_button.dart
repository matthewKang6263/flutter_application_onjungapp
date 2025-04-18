import 'package:flutter/material.dart';

/// 금액 빠르게 추가할 수 있는 버튼 컴포넌트
/// [label]은 버튼에 표시할 텍스트 (예: '+3만', '+5만')
/// [onTap]은 버튼을 클릭했을 때 실행되는 함수
class MoneyQuickAddButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const MoneyQuickAddButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40, // ✅ 버튼 높이 고정
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFE9E5E1),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center, // ✅ 텍스트 수직·수평 중앙 정렬
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF2A2928),
            fontSize: 16, // ✅ 시안에 맞춰 크게
            fontWeight: FontWeight.w500, // ✅ 더 굵게
            fontFamily: 'Pretendard',
          ),
        ),
      ),
    );
  }
}
