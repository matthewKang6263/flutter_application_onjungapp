// lib/components/buttons/contact_add_button.dart

import 'package:flutter/material.dart';

/// 🔹 연락처 리스트 '추가' / '추가됨' 버튼
/// - [isAdded]: 상태, [onTap]: 추가 콜백
class ContactAddButton extends StatelessWidget {
  final bool isAdded;
  final String label;
  final VoidCallback? onTap;

  const ContactAddButton({
    super.key,
    required this.isAdded,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isAdded ? null : onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isAdded ? const Color(0xFFF9F4EE) : const Color(0xFFC9885C),
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Pretendard',
            color: isAdded ? const Color(0xFFB5B1AA) : const Color(0xFFF9F4EE),
          ),
        ),
      ),
    );
  }
}
