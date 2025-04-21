// lib/components/app_bar/custom_sub_app_bar.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 🔹 서브 화면 앱바 위젯
/// - 좌측 뒤로가기, 중앙 타이틀, 우측 placeholder
class CustomSubAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // 중앙에 표시할 제목

  const CustomSubAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ◻️ 뒤로가기 버튼
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: SvgPicture.asset(
                'assets/icons/back.svg',
                width: 24,
                height: 24,
                color: Colors.black,
              ),
            ),
            // ◼︎ 중앙 타이틀
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Pretendard',
              ),
            ),
            // ◻️ 우측 placeholder
            const Opacity(
              opacity: 0,
              child: SizedBox(width: 24, height: 24),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
