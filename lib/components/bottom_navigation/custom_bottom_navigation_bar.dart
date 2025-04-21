// lib/components/bottom_navigation/custom_bottom_navigation_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/bottom_navigation/nav_item.dart';

/// 🔹 커스텀 바텀 네비게이션 바
/// - 탭 인덱스 및 onTap 콜백 처리
class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8F7F3),
        border: Border(top: BorderSide(color: Color(0xFFE8E8E6), width: 1)),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 40, left: 24, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NavItem(
            label: '홈',
            iconPath: 'assets/icons/home_default.svg',
            selectedIconPath: 'assets/icons/home_selected.svg',
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          NavItem(
            label: '친구',
            iconPath: 'assets/icons/friends_default.svg',
            selectedIconPath: 'assets/icons/friends_selected.svg',
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          NavItem(
            label: '캘린더',
            iconPath: 'assets/icons/calendar_default.svg',
            selectedIconPath: 'assets/icons/calendar_selected.svg',
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          NavItem(
            label: '내 경조사',
            iconPath: 'assets/icons/my_events_default.svg',
            selectedIconPath: 'assets/icons/my_events_selected.svg',
            isSelected: currentIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}
