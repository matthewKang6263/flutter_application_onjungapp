// 📁 lib/pages/auth/splash_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/viewmodels/auth/user_view_model.dart';

/// 🔹 앱 실행 시 첫 화면으로, 사용자 정보 복원 후 라우팅 처리
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// ⚙️ 앱 초기화 로직
  Future<void> _initializeApp() async {
    final userVM = ref.read(userViewModelProvider.notifier);

    // 1) SharedPreferences에서 로그인 정보 복원
    await userVM.restoreUserFromPrefs();
    debugPrint('🔄 복원된 UID: ${ref.read(userViewModelProvider).uid}');

    // 2) 스플래시 화면 최소 노출 시간
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // 3) 만약 arguments로 메시지가 전달되었다면 스낵바로 표시
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(args)));
      });
    }

    // 4) 로그인 상태에 따라 이동
    final isLoggedIn = ref.read(userViewModelProvider).isLoggedIn;
    Navigator.pushReplacementNamed(
      context,
      isLoggedIn ? '/home' : '/login',
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFC9885C),
      body: SafeArea(
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
    );
  }
}
