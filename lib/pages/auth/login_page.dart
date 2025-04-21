// 📁 lib/pages/auth/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_onjungapp/viewmodels/auth/user_view_model.dart';

/// 🔹 로그인 페이지
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isLoading = false;

  /// ⚙️ 공통 로그인 핸들러
  Future<void> _onLogin(Future<void> Function() method) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      await method();
      final loggedIn = ref.read(userViewModelProvider).isLoggedIn;
      if (mounted && loggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인에 실패했어요')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(child: SizedBox()),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '마음이 오가는 순간을\n기억하세요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.36,
                  color: Color(0xFF2A2928),
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // 카카오 로그인
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _onLogin(
                                ref
                                    .read(userViewModelProvider.notifier)
                                    .signInWithKakao,
                              ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF9DB37),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  color: Color(0xFF2A2928), strokeWidth: 2),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/icons/kakao_icon.svg',
                                    width: 16, height: 16),
                                const SizedBox(width: 8),
                                const Text(
                                  '카카오로 시작하기',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2A2928),
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 디버그 로그인
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () => _onLogin(
                                ref
                                    .read(userViewModelProvider.notifier)
                                    .signInAsDebugUser,
                              ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        side: const BorderSide(
                            color: Color(0xFF2A2928), width: 1),
                      ),
                      child: const Text(
                        '디버그 로그인',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2A2928),
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            GestureDetector(
              onTap: () {
                if (!_isLoading) {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
              child: const Padding(
                padding: EdgeInsets.only(bottom: 64),
                child: Text(
                  '로그인하지 않고 둘러보기',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFB5B1AA),
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
