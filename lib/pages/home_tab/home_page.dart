import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/pages/auth/login_page.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_add/my_event_add_step1_page.dart';
import 'package:flutter_application_onjungapp/pages/quick_record/quick_record_step1.dart';
import 'package:flutter_application_onjungapp/pages/home_tab/widgets/home_info_card.dart';
import 'package:flutter_application_onjungapp/pages/home_tab/widgets/home_stat_card.dart';
import 'package:flutter_application_onjungapp/viewmodels/home_tab/home_view_model.dart';
import 'package:flutter_application_onjungapp/viewmodels/auth/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hasLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoaded) {
      final vm = context.read<HomeViewModel>();
      final userViewModel = context.read<UserViewModel>();
      final userId = userViewModel.uid ?? 'test-user';

      // 🔥 빌드 이후 로드하도록 delay
      WidgetsBinding.instance.addPostFrameCallback((_) {
        vm.loadData(userId);
      });

      _hasLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewModel>();
    final userViewModel = context.watch<UserViewModel>();

    final formattedReceived =
        NumberFormat('#,###').format(homeViewModel.stats.receivedAmount);
    final formattedSent =
        NumberFormat('#,###').format(homeViewModel.stats.sentAmount);

    final isLoggedIn = userViewModel.isLoggedIn;
    final nickname = userViewModel.nickname ?? '사용자';

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 상단 회색 배경 영역
          Container(
            color: const Color(0xFFE9E5E1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔸 로그인 상태 문구
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
                              builder: (_) => const LoginPage(),
                            ),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFFC9885C),
                                  width: 1.2,
                                ),
                              ),
                            ),
                            child: const Text(
                              '로그인을 해주세요',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFC9885C),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                          ),
                        ),
                ),

                // 🔸 내 경조사 정리 카드
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MyEventAddStep1Page(),
                      ),
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
                          color: Color(0xFF2A2928),
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // 🔸 통계 카드
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: HomeStatCard(
                          title: '받은 마음',
                          amount: '$formattedReceived원',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: HomeStatCard(
                          title: '보낸 마음',
                          amount: '$formattedSent원',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),

          // 🔹 하단 콘텐츠
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '온정이 처음이신가요?',
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
                    subtitle: '온정 서비스는 이렇게 진행돼요',
                  ),
                  const SizedBox(height: 12),
                  HomeInfoCard(
                    title: '빠른 기록',
                    subtitle: '간편하게 내역을 등록할 수 있어요',
                    iconPath: 'assets/icons/thunder.svg',
                    iconAfterTitle: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QuickRecordStep1Page(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
