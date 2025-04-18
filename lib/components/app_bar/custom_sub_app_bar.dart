import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 서브/세부 화면에서 사용하는 상단 앱바 컴포넌트입니다.
/// 가운데 타이틀 + 좌측 뒤로가기 버튼 + 우측 placeholder 로 정렬 유지
class CustomSubAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // 가운데 타이틀 텍스트

  const CustomSubAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양쪽 끝 정렬
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 뒤로가기 버튼 (좌측)
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: SvgPicture.asset(
                'assets/icons/back.svg',
                width: 24,
                height: 24,
                color: Colors.black, // SVG가 회색이라도 덮어씌움
              ),
            ),

            // 가운데 타이틀
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Pretendard',
              ),
            ),

            // 우측 placeholder (아이콘과 같은 크기로 맞춤용)
            const Opacity(
              opacity: 0, // 안 보이지만 공간 차지
              child: SizedBox(
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64); // AppBar 높이
}
