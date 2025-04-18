import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_onjungapp/viewmodels/auth/user_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;

  Future<void> _handleLogin(Future<void> Function() signInMethod) async {
    if (isLoading) return;

    setState(() => isLoading = true);
    try {
      final userViewModel = context.read<UserViewModel>();
      await signInMethod();
      debugPrint('✅ 로그인 후 isLoggedIn: ${userViewModel.isLoggedIn}');
      if (mounted && userViewModel.isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      print('로그인 실패: $e'); // ✅ 콘솔 로그 추가
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인에 실패했어요')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
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

            // 가운데 문구
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
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

            // 버튼 영역
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // 카카오 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () => _handleLogin(
                        context.read<UserViewModel>().signInWithKakao,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF9DB37),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          color: Color(0xFF2A2928),
                          strokeWidth: 2,
                        ),
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/kakao_icon.svg',
                            width: 16,
                            height: 16,
                          ),
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

                  // 애플 버튼
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: OutlinedButton(
                  //     onPressed: isLoading
                  //         ? null
                  //         : () => _handleLogin(
                  //               context.read<UserViewModel>().signInWithApple,
                  //             ),
                  //     style: OutlinedButton.styleFrom(
                  //       padding: const EdgeInsets.symmetric(vertical: 16),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(1000),
                  //       ),
                  //       side: const BorderSide(
                  //         color: Color(0xFF2A2928),
                  //         width: 1,
                  //       ),
                  //     ),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         SvgPicture.asset(
                  //           'assets/icons/apple_icon.svg',
                  //           width: 16,
                  //           height: 16,
                  //         ),
                  //         const SizedBox(width: 8),
                  //         const Text(
                  //           'Apple로 시작하기',
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w700,
                  //             color: Color(0xFF2A2928),
                  //             fontFamily: 'Pretendard',
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  const SizedBox(height: 12),

                  // ✅ 디버그 로그인 버튼
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: isLoading
                          ? null
                          : () => _handleLogin(
                        context.read<UserViewModel>().signInAsDebugUser,
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        side: const BorderSide(
                          color: Color(0xFF2A2928),
                          width: 1,
                        ),
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

            // '로그인하지 않고 둘러보기'
            GestureDetector(
              onTap: () {
                if (!isLoading) {
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