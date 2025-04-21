// 📁 lib/pages/root_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_main_app_bar.dart';
import 'package:flutter_application_onjungapp/components/bottom_navigation/custom_bottom_navigation_bar.dart';
import 'package:flutter_application_onjungapp/pages/calendar_tab/calendar_page.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/friends_page.dart';
import 'package:flutter_application_onjungapp/pages/home_tab/home_page.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_events_page.dart';
import 'package:flutter_application_onjungapp/pages/auth/settings_page.dart';

/// 🔹 메인 탭 내비게이션 컨테이너
class RootPage extends StatefulWidget {
  final int initialIndex;
  const RootPage({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  late int _currentIndex = widget.initialIndex;

  // 각 탭 페이지 리스트
  static const _pages = [
    HomePage(),
    FriendsPage(),
    CalendarPage(),
    MyEventsPage(),
  ];
  // 각 탭 타이틀
  static const _titles = ['홈', '주소록', '캘린더', '내경조사'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 상단 AppBar
      appBar: CustomMainAppBar(
        title: _titles[_currentIndex],
        backgroundColor:
            _currentIndex == 0 ? const Color(0xFFE9E5E1) : Colors.white,
        onSettingsTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsPage()),
          );
        },
        showEditIcon: false,
      ),
      // 탭별 body
      body: _pages[_currentIndex],
      // 하단 내비게이션
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
      ),
    );
  }
}
