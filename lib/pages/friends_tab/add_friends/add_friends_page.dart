// 📁 lib/pages/friends_tab/add_friends/add_friends_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/add_friends/view/contact_sync_view.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/add_friends/view/direct_add_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/buttons/rounded_toggle_button.dart';

/// 🆕 친구 추가 페이지
///  - 상단 서브 앱바
///  - 탭 토글: 연락처 동기화 / 직접 추가
///  - IndexedStack 으로 콘텐츠 전환
class AddFriendsPage extends ConsumerStatefulWidget {
  const AddFriendsPage({super.key});

  @override
  ConsumerState<AddFriendsPage> createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends ConsumerState<AddFriendsPage> {
  int selectedTab = 0; // 0: 연락처 동기화, 1: 직접 추가

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 서브 앱바
            const CustomSubAppBar(title: '친구 추가'),
            // 토글 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: RoundedToggleButton(
                leftText: '연락처 동기화',
                rightText: '직접 추가',
                isLeftSelected: selectedTab == 0,
                onToggle: (isLeft) =>
                    setState(() => selectedTab = isLeft ? 0 : 1),
              ),
            ),
            // 탭별 콘텐츠
            Expanded(
              child: IndexedStack(
                index: selectedTab,
                children: const [
                  ContactSyncView(),
                  DirectAddView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
