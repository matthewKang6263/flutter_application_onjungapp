import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/buttons/rounded_toggle_button.dart';
import 'view/contact_sync_view.dart';
import 'view/direct_add_view.dart';

/// 🧾 친구 추가 메인 페이지
/// - 상단 앱바 + 토글 버튼 + 탭 콘텐츠
/// - 탭 전환: 연락처 동기화 / 직접 추가
class AddFriendsPage extends StatefulWidget {
  const AddFriendsPage({super.key});

  @override
  State<AddFriendsPage> createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  int selectedTabIndex = 0; // 🔹 0: 연락처 동기화, 1: 직접 추가

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ SafeArea로 감싸 화면 안정성 확보
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 커스텀 서브 앱바
            const CustomSubAppBar(title: '친구 추가'),

            // 🔹 탭 전환 토글 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: RoundedToggleButton(
                leftText: '연락처 동기화',
                rightText: '직접 추가',
                isLeftSelected: selectedTabIndex == 0,
                onToggle: (isLeft) {
                  setState(() {
                    selectedTabIndex = isLeft ? 0 : 1;
                  });
                },
              ),
            ),

            // 🔹 탭별 콘텐츠 표시
            Expanded(
              child: IndexedStack(
                index: selectedTabIndex,
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
