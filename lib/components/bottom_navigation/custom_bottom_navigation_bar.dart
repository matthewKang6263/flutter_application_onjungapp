import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/bottom_navigation/nav_item.dart';

/// 우리가 만든 커스텀 바텀 네비게이션 바 위젯
/// 하단 고정 영역에 사용되며, 현재 선택된 탭 인덱스와 탭 변경 콜백을 받아 처리합니다.
class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex; // 현재 선택된 탭 인덱스
  final Function(int) onTap; // 탭 클릭 시 실행할 콜백

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // 배경 및 테두리 스타일 적용
      decoration: const BoxDecoration(
        color: Color(0xFFF8F7F3), // 배경색
        border: Border(
          top: BorderSide(color: Color(0xFFE8E8E6), width: 1), // 상단 테두리
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24), // 좌측 상단 라운드
          topRight: Radius.circular(24), // 우측 상단 라운드
        ),
      ),
      // 시안 기준 padding 적용 (좌우는 줄여서 overflow 방지)
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 40,
        left: 24, // ← 기존 42에서 줄임
        right: 24,
      ),
      // 네비게이션 아이템을 가로로 배치
      child: Row(
        mainAxisSize: MainAxisSize.max, // 화면 전체 너비 사용
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // 아이템을 균등하게 배치
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 홈 탭
          NavItem(
            iconPath: 'assets/icons/home_default.svg',
            selectedIconPath: 'assets/icons/home_selected.svg',
            label: '홈',
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),

          // 주소록 탭
          NavItem(
            iconPath: 'assets/icons/friends_default.svg',
            selectedIconPath: 'assets/icons/friends_selected.svg',
            label: '친구',
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),

          // 캘린더 탭
          NavItem(
            iconPath: 'assets/icons/calendar_default.svg',
            selectedIconPath: 'assets/icons/calendar_selected.svg',
            label: '캘린더',
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
          ),

          // 내경조사 탭
          NavItem(
            iconPath: 'assets/icons/my_events_default.svg',
            selectedIconPath: 'assets/icons/my_events_selected.svg',
            label: '내 경조사',
            isSelected: currentIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}
