// lib/components/bottom_navigation/nav_item.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 🔹 바텀 네비게이션 바의 개별 탭 아이템
/// - 아이콘, 라벨, 선택 상태 등을 설정
class NavItem extends StatelessWidget {
  final String label;
  final String iconPath;
  final String selectedIconPath;
  final bool isSelected;
  final VoidCallback onTap;

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
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: SvgPicture.asset(
                isSelected ? selectedIconPath : iconPath,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? const Color(0xFFC9885C)
                    : const Color(0xFFB5B1AA),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
