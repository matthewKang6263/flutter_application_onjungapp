// lib/components/app_bar/custom_main_app_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 🔹 메인 앱바 위젯
/// - 타이틀은 왼쪽 정렬
/// - 오른쪽에는 설정 아이콘 및 (조건부) 편집 아이콘 표시
class CustomMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // 앱바 제목
  final VoidCallback? onSettingsTap; // 설정 아이콘 탭 콜백
  final VoidCallback? onEditTap; // 편집 아이콘 탭 콜백
  final bool showEditIcon; // 편집 아이콘 표시 여부
  final Color backgroundColor; // 앱바 배경색

  const CustomMainAppBar({
    super.key,
    required this.title,
    this.onSettingsTap,
    this.onEditTap,
    this.showEditIcon = false,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ● 왼쪽 타이틀
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF2A2928),
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Pretendard',
              ),
            ),
            // ● 오른쪽 아이콘 그룹
            Row(
              children: [
                if (showEditIcon) ...[
                  // ◻️ 편집 아이콘
                  GestureDetector(
                    onTap: onEditTap,
                    child: SvgPicture.asset(
                      'assets/icons/edit.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                // ◻️ 설정 아이콘
                GestureDetector(
                  onTap: onSettingsTap,
                  child: SvgPicture.asset(
                    'assets/icons/settings.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
