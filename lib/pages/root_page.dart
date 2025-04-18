// 📁 lib/pages/root_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_main_app_bar.dart';
import 'package:flutter_application_onjungapp/components/bottom_navigation/custom_bottom_navigation_bar.dart';
import 'package:flutter_application_onjungapp/pages/calendar_tab/calendar_page.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/friends_page.dart';
import 'package:flutter_application_onjungapp/pages/home_tab/home_page.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_events_page.dart';
import 'package:flutter_application_onjungapp/pages/auth/settings_page.dart';

/// 앱의 메인 루트 페이지
class RootPage extends StatefulWidget {
  final int initialIndex;

  const RootPage({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  late int _currentIndex = widget.initialIndex;

  final List<Widget> _pages = const [
    HomePage(),
    FriendsPage(),
    CalendarPage(),
    MyEventsPage(),
  ];

  final List<String> _titles = const [
    '홈',
    '주소록',
    '캘린더',
    '내경조사',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        showEditIcon: false, // 🔹 편집 아이콘 제거
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        color: Colors.white,
        child: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}
