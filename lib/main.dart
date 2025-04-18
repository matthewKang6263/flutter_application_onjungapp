// ✅ 1. main.dart 수정
// 📁 lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_onjungapp/pages/auth/login_page.dart';
import 'package:flutter_application_onjungapp/pages/splash_page.dart';
import 'package:flutter_application_onjungapp/pages/root_page.dart';
import 'package:flutter_application_onjungapp/viewmodels/auth/user_view_model.dart';
import 'package:flutter_application_onjungapp/viewmodels/home_tab/home_view_model.dart';
import 'package:flutter_application_onjungapp/viewmodels/quick_record/quick_record_view_model.dart';
import 'package:flutter_application_onjungapp/viewmodels/search/search_friend_view_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_application_onjungapp/viewmodels/calendar_tab/calendar_tab_viewmodel.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  KakaoSdk.init(nativeAppKey: '51b0a5c024b1ff7f585b4ee6c4ceaf2d');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalendarTabViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => QuickRecordViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => SearchFriendViewModel()),
        // 필요한 ViewModel 계속 추가
      ],
      child: const OnjeongApp(),
    ),
  );
}

class OnjeongApp extends StatelessWidget {
  const OnjeongApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '온정',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Pretendard',
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const RootPage(),
      },
    );
  }
}
