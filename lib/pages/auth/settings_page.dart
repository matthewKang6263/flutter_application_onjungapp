import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/dialogs/confirm_action_dialog.dart';
import 'package:flutter_application_onjungapp/components/dividers/thick_divider.dart';
import 'package:flutter_application_onjungapp/components/dividers/thin_divider.dart';
import 'package:flutter_application_onjungapp/pages/auth/cancel_account_page.dart';
import 'package:flutter_application_onjungapp/pages/auth/widgets/settings_list_item.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_onjungapp/viewmodels/auth/user_view_model.dart';

class SettingsPage extends StatelessWidget {
  final bool isLoggedIn;

  const SettingsPage({Key? key, this.isLoggedIn = true}) : super(key: key);

  // 🔹 로그인 페이지로 이동 (예시)
  void _goToLoginPage(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  // 🔹 회원탈퇴 페이지로 이동
  void _goToCancelAccountPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CancelAccountPage()),
    );
  }

  // 🔹 로그아웃 다이얼로그 표시
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) => ConfirmActionDialog(
        title: '정말 로그아웃 할까요?',
        cancelText: '취소',
        confirmText: '로그아웃',
        onCancel: () => Navigator.pop(context),
        onConfirm: () async {
          Navigator.pop(context); // 다이얼로그 닫기
          final userViewModel = context.read<UserViewModel>();
          await userViewModel.signOut();

          // ✅ 메시지 전달하며 로그인 페이지로 이동
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
            arguments: '로그아웃 되었습니다',
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = context.watch<UserViewModel>();
    final isLoggedIn = userViewModel.isLoggedIn;
    final nickname = userViewModel.nickname ?? '사용자';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomSubAppBar(title: '설정'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 로그인 유저 이름 or 로그인 유도 문구
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: isLoggedIn
                ? Text(
                    '$nickname님',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Pretendard',
                      color: Color(0xFF2A2928),
                    ),
                  )
                : GestureDetector(
                    onTap: () => _goToLoginPage(context),
                    child: const Text(
                      '로그인을 해주세요',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                      ),
                    ),
                  ),
          ),

          const ThickDivider(),

          SettingsListItem(
            title: '개인정보 처리 방침',
            trailing: SvgPicture.asset(
              'assets/icons/front.svg',
              width: 20,
              height: 20,
              color: const Color(0xFFB5B1AA),
            ),
            onTap: () {},
          ),

          const ThinDivider(),

          const SettingsListItem(
            title: '앱 버전',
            trailing: Text(
              'V 1.1.1',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Pretendard',
                color: Color(0xFFB5B1AA),
              ),
            ),
          ),

          const ThickDivider(),

          // ✅ 로그아웃
          SettingsListItem(
            title: '로그아웃',
            onTap: () => _showLogoutDialog(context),
          ),

          const ThinDivider(),

          // ✅ 회원탈퇴
          SettingsListItem(
            title: '회원탈퇴',
            onTap: () {
              final userViewModel = context.read<UserViewModel>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CancelAccountPage(
                      userName: userViewModel.nickname ?? '사용자'),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
