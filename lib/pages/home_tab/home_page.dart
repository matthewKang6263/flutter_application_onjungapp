// 📁 lib/pages/home_tab/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/pages/quick_record/quick_record_step1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:flutter_application_onjungapp/viewmodels/auth/user_view_model.dart';
import 'package:flutter_application_onjungapp/viewmodels/home_tab/home_view_model.dart';

import 'package:flutter_application_onjungapp/pages/auth/login_page.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_add/my_event_add_step1_page.dart';
import 'package:flutter_application_onjungapp/pages/home_tab/widgets/home_info_card.dart';
import 'package:flutter_application_onjungapp/pages/home_tab/widgets/home_stat_card.dart';

/// 🏠 홈 탭 메인 페이지
class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      // 로그인된 유저 ID 가져오기
      final userId = ref.read(userViewModelProvider).uid;
      // HomeViewModel 로드
      if (userId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(homeViewModelProvider.notifier).loadData(userId);
        });
      }
      _loaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);
    final userState = ref.watch(userViewModelProvider);

    final isLoggedIn = userState.isLoggedIn;
    final nickname = userState.nickname ?? '사용자';

    // intl 포맷으로 숫자 포맷팅
    final received =
        NumberFormat('#,###').format(homeState.stats.receivedAmount);
    final sent = NumberFormat('#,###').format(homeState.stats.sentAmount);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 그레이 영역
              Container(
                color: const Color(0xFFE9E5E1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 로그인 환영 문구 또는 로그인 안내
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: isLoggedIn
                          ? Text(
                              '$nickname님, 반가워요 👋',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Pretendard',
                                color: Color(0xFF2A2928),
                              ),
                            )
                          : GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginPage()),
                              ),
                              child: const Text(
                                '로그인을 해주세요',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  color: Color(0xFFC9885C),
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                            ),
                    ),
                    // 내 경조사 정리 카드
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MyEventAddStep1Page()),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '지난 경조사가 있었나요?\n장부 내역을 등록해보세요',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              height: 1.36,
                              fontFamily: 'Pretendard',
                              color: Color(0xFF2A2928),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 통계 카드
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: HomeStatCard(
                              title: '받은 마음',
                              amount: '$received원',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: HomeStatCard(
                              title: '보낸 마음',
                              amount: '$sent원',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              // 하단 안내 영역
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '처음이신가요?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Pretendard',
                        color: Color(0xFF2A2928),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const HomeInfoCard(
                      title: '온정 사용 설명서',
                      subtitle: '서비스 이용 방법을 안내해 드립니다',
                    ),
                    const SizedBox(height: 12),
                    HomeInfoCard(
                      title: '빠른 기록',
                      subtitle: '간편하게 내역을 등록해 보세요',
                      iconPath: 'assets/icons/thunder.svg',
                      iconAfterTitle: true,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const QuickRecordStep1Page()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
