// components/bottom_navigation/nav_item.dart
// 바텀 네비게이션 바의 개별 아이템 위젯입니다.
// 아이콘, 선택 여부, 라벨 등을 설정할 수 있습니다.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavItem extends StatelessWidget {
  final String label; // 탭 이름 텍스트
  final String iconPath; // 선택되지 않은 상태의 아이콘 경로
  final String selectedIconPath; // 선택된 상태의 아이콘 경로
  final bool isSelected; // 현재 탭이 선택되었는지 여부
  final VoidCallback onTap; // 탭 클릭 시 실행할 콜백

  const NavItem({
    super.key,
    required this.label,
    required this.iconPath,
    required this.selectedIconPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 80, // 전체 아이템의 가로폭 고정
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: SvgPicture.asset(
                isSelected ? selectedIconPath : iconPath, // 상태에 따라 아이콘 변경
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 48, // 텍스트 최대 너비 제한
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFFC9885C) // 선택된 탭 색상
                      : const Color(0xFFB5B1AA), // 선택되지 않은 탭 색상
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
