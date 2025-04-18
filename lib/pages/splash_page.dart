import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/viewmodels/auth/user_view_model.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final userViewModel = context.read<UserViewModel>();

    // 로그인 정보 복원 시도
    await userViewModel.restoreUserFromPrefs();
    debugPrint("🔄 복원된 uid: ${userViewModel.uid}");

    // 2초 대기 후 홈 또는 로그인 이동
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final message = ModalRoute.of(context)?.settings.arguments as String?;

    // 메시지 전달 여부 확인 → Snackbar 표시
    if (message != null && message.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      });
    }

    Navigator.pushReplacementNamed(
      context,
      userViewModel.isLoggedIn ? '/home' : '/login',
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFC9885C), // 피그마 배경색
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  '온정',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pretendard',
                    color: Colors.white,
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
