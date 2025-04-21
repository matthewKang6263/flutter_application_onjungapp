// 📁 lib/pages/auth/cancel_account_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_outline_button.dart';
import 'package:flutter_application_onjungapp/viewmodels/auth/user_view_model.dart';

/// 🔹 회원 탈퇴 안내 페이지
class CancelAccountPage extends ConsumerWidget {
  final String userName;

  const CancelAccountPage({super.key, this.userName = '사용자'});

  Widget _bullet(String line1, [String? line2]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF888580),
              fontWeight: FontWeight.w500,
              fontFamily: 'Pretendard',
              height: 1.5,
            )),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(line1,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF888580),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Pretendard',
                    height: 1.5,
                  )),
              if (line2 != null)
                Text(line2,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF888580),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Pretendard',
                      height: 1.5,
                    )),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomSubAppBar(title: ''),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              '$userName님,\n탈퇴 전 확인해주세요!',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2A2928),
                fontFamily: 'Pretendard',
                height: 1.36,
              ),
            ),
            const SizedBox(height: 32),
            _bullet('탈퇴한 번호로는 7일간 재가입이 불가능해요.'),
            const SizedBox(height: 12),
            _bullet(
              '개인정보, 서비스 이용 기록 등은 복원이 불가능하며,',
              '일정 기간 후 영구 삭제됩니다.',
            ),
            const Spacer(),
            SafeArea(
              top: false,
              child: Column(
                children: [
                  BlackFillButton(
                    text: '계속 이용하기',
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 8),
                  BlackOutlineButton(
                    text: '탈퇴하기',
                    onTap: () async {
                      await ref
                          .read(userViewModelProvider.notifier)
                          .deleteAccount();
                      Navigator.pushNamedAndRemoveUntil(
                        // ignore: use_build_context_synchronously
                        context,
                        '/login',
                        (_) => false,
                        arguments: '탈퇴 완료되었습니다',
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
