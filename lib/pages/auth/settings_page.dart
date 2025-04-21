// 📁 lib/pages/auth/settings_page.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/dividers/thick_divider.dart';
import 'package:flutter_application_onjungapp/components/dividers/thin_divider.dart';
import 'package:flutter_application_onjungapp/components/dialogs/confirm_action_dialog.dart';
import 'package:flutter_application_onjungapp/pages/auth/cancel_account_page.dart';
import 'package:flutter_application_onjungapp/pages/auth/widgets/settings_list_item.dart';
import 'package:flutter_application_onjungapp/viewmodels/auth/user_view_model.dart';

/// 🔹 설정 페이지
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => ConfirmActionDialog(
        title: '로그아웃 하시겠습니까?',
        cancelText: '취소',
        confirmText: '로그아웃',
        onCancel: () => Navigator.pop(context),
        onConfirm: () async {
          Navigator.pop(context);
          await ref.read(userViewModelProvider.notifier).signOut();
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false,
              arguments: '로그아웃 되었습니다');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userViewModelProvider);
    final nick = user.nickname ?? '사용자';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomSubAppBar(title: '설정'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 사용자 정보 또는 로그인 유도
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: user.isLoggedIn
                ? Text(
                    '$nick님',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Pretendard',
                      color: Color(0xFF2A2928),
                    ),
                  )
                : GestureDetector(
                    onTap: () => Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (_) => false),
                    child: const Text(
                      '로그인 해주세요',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ),
          ),
          const ThickDivider(),

          // 개인정보 처리방침
          SettingsListItem(
            title: '개인정보 처리방침',
            trailing: SvgPicture.asset(
              'assets/icons/front.svg',
              width: 20,
              height: 20,
              color: const Color(0xFFB5B1AA),
            ),
            onTap: () {
              // TODO: 정책 페이지 연결
            },
          ),
          const ThinDivider(),

          // 앱 버전 표시
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

          // 로그아웃
          SettingsListItem(
            title: '로그아웃',
            onTap: () => _confirmLogout(context, ref),
          ),
          const ThinDivider(),

          // 회원탈퇴
          SettingsListItem(
            title: '회원탈퇴',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CancelAccountPage(userName: nick),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
