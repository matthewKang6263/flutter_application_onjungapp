import 'package:flutter/material.dart';

/// 검정 배경 + 흰 글씨의 기본 버튼 위젯
/// [text]는 버튼 안의 텍스트이며,
/// [onTap]은 클릭 시 실행될 콜백입니다.
/// [icon]이 있을 경우 텍스트 오른쪽에 함께 표시됩니다.
class BlackFillButton extends StatelessWidget {
  final String text; // 버튼에 표시될 텍스트
  final VoidCallback onTap; // 버튼 클릭 시 실행될 함수
  final Widget? icon; // 텍스트 우측에 표시할 아이콘 (선택)

  const BlackFillButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon, // 기본값: 없음
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 버튼 클릭 시 콜백 실행
      child: Container(
        width: double.infinity, // 버튼 전체 너비 사용
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: ShapeDecoration(
          color: const Color(0xFF2A2928), // 검정 배경
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000), // 완전 둥근 모서리
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // 텍스트 + 아이콘 크기만큼만
          mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 버튼 텍스트
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white, // 흰색 텍스트
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Pretendard',
              ),
            ),

            // 아이콘이 있을 경우 텍스트 오른쪽에 표시
            if (icon != null) ...[
              const SizedBox(width: 6), // 텍스트와 아이콘 사이 간격
              icon!,
            ],
          ],
        ),
      ),
    );
  }
}
