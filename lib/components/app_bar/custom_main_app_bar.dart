import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 메인 앱바 위젯
/// - 타이틀은 항상 왼쪽 정렬
/// - 오른쪽에는 설정 아이콘 + (조건부) 편집 아이콘
class CustomMainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // 타이틀 텍스트
  final VoidCallback? onSettingsTap; // 설정 아이콘 콜백
  final VoidCallback? onEditTap; // 편집 아이콘 콜백
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        color: backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 🔹 타이틀 (항상 왼쪽 정렬)
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF2A2928),
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Pretendard',
              ),
            ),

            // 🔹 오른쪽 아이콘들 (편집 아이콘 + 설정 아이콘)
            Row(
              children: [
                if (showEditIcon)
                  GestureDetector(
                    onTap: onEditTap,
                    child: SvgPicture.asset(
                      'assets/icons/edit.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                if (showEditIcon) const SizedBox(width: 16), // 아이콘 간격

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
