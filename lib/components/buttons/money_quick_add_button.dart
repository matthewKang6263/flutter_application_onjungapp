// lib/components/buttons/money_quick_add_button.dart

import 'package:flutter/material.dart';

/// 🔹 금액 빠른 추가 버튼
/// - [label]: '+3만' 등, [onTap]: 콜백
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
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE9E5E1), width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
              color: Color(0xFF2A2928),
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Pretendard'),
        ),
      ),
    );
  }
}
