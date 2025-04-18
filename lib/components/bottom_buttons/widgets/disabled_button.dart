import 'package:flutter/material.dart';

/// 비활성화된 회색 배경 버튼 위젯
/// 클릭 이벤트는 없고 텍스트만 표시됩니다.
class DisabledButton extends StatelessWidget {
  final String text; // 버튼에 표시될 텍스트

  const DisabledButton({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: ShapeDecoration(
        color: const Color(0xFFE9E5E1), // 비활성화 배경색
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1000),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFB5B1AA), // 흐린 회색 텍스트
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Pretendard',
            ),
          ),
        ],
      ),
    );
  }
}
