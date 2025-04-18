import 'package:flutter/material.dart';

/// 검정 테두리 + 투명 배경의 아웃라인 버튼 위젯
/// [text]는 버튼 텍스트, [onTap]은 클릭 시 콜백 함수입니다.
class BlackOutlineButton extends StatelessWidget {
  final String text; // 버튼 텍스트
  final VoidCallback onTap; // 버튼 클릭 시 콜백

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
            side: const BorderSide(
              color: Color(0xFF2A2928), // 검정 테두리
              width: 1,
            ),
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
                color: Color(0xFF2A2928), // 검정 텍스트
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Pretendard',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
