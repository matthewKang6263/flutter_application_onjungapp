// 📁 lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'firebase_options.dart';
import 'package:flutter_application_onjungapp/pages/auth/login_page.dart';
import 'package:flutter_application_onjungapp/pages/splash_page.dart';
import 'package:flutter_application_onjungapp/pages/root_page.dart';

/// 🔹 앱 진입점
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣ Intl 한글 로케일 데이터 초기화
  await initializeDateFormatting('ko_KR', null);

  // 2️⃣ Firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3️⃣ Kakao SDK 초기화
  KakaoSdk.init(nativeAppKey: '51b0a5c024b1ff7f585b4ee6c4ceaf2d');

  // 4️⃣ Riverpod ProviderScope로 앱 실행
  runApp(const ProviderScope(child: OnjeongApp()));
}

/// 🔹 최상위 앱 위젯
class OnjeongApp extends StatelessWidget {
  const OnjeongApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '온정',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Pretendard',
      ),
      // 다국어 지원 설정
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      // 라우트 설정
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const RootPage(),
      },
    );
  }
}
