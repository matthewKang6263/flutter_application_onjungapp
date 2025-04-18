import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_outline_button.dart';
import 'package:flutter_application_onjungapp/viewmodels/auth/user_view_model.dart';
import 'package:provider/provider.dart';

/// 회원 탈퇴 안내 페이지
class CancelAccountPage extends StatelessWidget {
  final String userName;

  const CancelAccountPage({super.key, this.userName = '강민우'});

  Widget _buildSingleBulletText(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(
            color: Color(0xFF888580),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Pretendard',
            height: 1.5,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF888580),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Pretendard',
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDoubleBulletText(String line1, String line2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '• ',
          style: TextStyle(
            color: Color(0xFF888580),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Pretendard',
            height: 1.5,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                line1,
                style: const TextStyle(
                  color: Color(0xFF888580),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Pretendard',
                  height: 1.5,
                ),
              ),
              Text(
                line2,
                style: const TextStyle(
                  color: Color(0xFF888580),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Pretendard',
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = context.read<UserViewModel>();

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
              '$userName님,\n탈퇴하기 전 꼭 확인해 주세요!',
              style: const TextStyle(
                color: Color(0xFF2A2928),
                fontSize: 22,
                fontWeight: FontWeight.w700,
                fontFamily: 'Pretendard',
                height: 1.36,
              ),
            ),
            const SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSingleBulletText('탈퇴한 휴대폰 번호로는 7일간 재가입이 불가능해요.'),
                const SizedBox(height: 12),
                _buildDoubleBulletText(
                  '개인정보, 서비스 이용 기록 등은 복원이 불가능하며,',
                  '일정 기간 후 영구 삭제돼요.',
                ),
                const SizedBox(height: 12),
                _buildDoubleBulletText(
                  '개인정보, 서비스 이용 기록 등은 복원이 불가능하며,',
                  '일정 기간 후 영구 삭제돼요.',
                ),
              ],
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
                  // 🔸 탈퇴하기 버튼 (변경된 부분만 발췌)
                  BlackOutlineButton(
                    text: '탈퇴하기',
                    onTap: () async {
                      final userViewModel = context.read<UserViewModel>();
                      await userViewModel.deleteAccount();

                      // ✅ 탈퇴 완료 메시지 전달하며 로그인 페이지로 이동
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
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
