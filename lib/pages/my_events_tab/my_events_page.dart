// 📁 lib/pages/my_events_tab/my_events_page.dart

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/viewmodels/my_events_tab/my_events_view_model.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/widgets/my_event_card.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_add/my_event_add_step1_page.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_detail/my_event_detail_page.dart';
import 'package:flutter_application_onjungapp/components/wrappers/cupertino_touch_wrapper.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 📄 내 경조사 탭 메인 페이지 (Riverpod 기반)
class MyEventsPage extends ConsumerStatefulWidget {
  const MyEventsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyEventsPage> createState() => _MyEventsPageState();
}

class _MyEventsPageState extends ConsumerState<MyEventsPage> {
  static const String userId = 'test-user'; // TODO: 로그인 연동 예정

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myEventsViewModelProvider.notifier).loadAll(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myEventsViewModelProvider);
    final events = state.events;
    final isLoading = state.isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '나의 경조사 내역을\n기록해 보세요!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.36,
                  color: Color(0xFF2A2928),
                  fontFamily: 'Pretendard',
                ),
              ),
              const SizedBox(height: 24),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (events.isNotEmpty)
                      ...events.map((event) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: MyEventCard(
                              title: event.title,
                              eventType: event.eventType.label,
                              date: event.date,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        MyEventDetailPage(event: event),
                                  ),
                                );
                              },
                            ),
                          )),
                    const SizedBox(height: 12),
                    MyEventAddCard(userId: userId),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ➕ 경조사 추가 카드
class MyEventAddCard extends ConsumerWidget {
  final String userId;
  const MyEventAddCard({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoTouchWrapper(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MyEventAddStep1Page()),
        ).then((_) {
          ref.read(myEventsViewModelProvider.notifier).loadAll(userId);
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(top: 2),
        child: DottedBorder(
          color: const Color(0xFFDDD9D5),
          strokeWidth: 2,
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          dashPattern: const [6, 4],
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF9F4EE),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/btn_add_lg.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    '경조사 추가하기',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2A2928),
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
