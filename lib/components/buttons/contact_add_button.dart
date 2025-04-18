import 'package:flutter/material.dart';

/// 연락처 리스트 등에서 사용하는 '추가' / '추가됨' 버튼 컴포넌트
class ContactAddButton extends StatelessWidget {
  final bool isAdded; // 추가된 상태 여부
  final String label; // 버튼에 표시할 텍스트
  final VoidCallback? onTap; // '추가'일 때만 동작하는 콜백

  const ContactAddButton({
    super.key,
    required this.isAdded,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isAdded ? null : onTap, // '추가됨'이면 클릭 비활성화
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
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            color: isAdded ? const Color(0xFFB5B1AA) : const Color(0xFFF9F4EE),
          ),
        ),
      ),
    );
  }
}
