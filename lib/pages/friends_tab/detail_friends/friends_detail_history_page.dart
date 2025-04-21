// 📁 lib/pages/friends_tab/detail_friends/friends_detail_history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/detail_friends/friends_detail_profile_page.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/detail_friends/widgets/event_record_list_item.dart';
import 'package:flutter_application_onjungapp/pages/quick_record/quick_record_step1.dart';
import 'package:flutter_application_onjungapp/utils/date/date_formats.dart';
import 'package:flutter_application_onjungapp/viewmodels/friends_tab/list/friend_list_view_model.dart';
import 'package:flutter_application_onjungapp/viewmodels/friends_tab/history/friend_event_record_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/box/exchange_summary_box.dart';
import 'package:flutter_application_onjungapp/components/buttons/rounded_toggle_button.dart';
import 'package:flutter_application_onjungapp/components/dividers/thick_divider.dart';
import 'package:flutter_application_onjungapp/components/dividers/thin_divider.dart';
import 'package:flutter_application_onjungapp/models/event_record_model.dart';
import 'package:flutter_application_onjungapp/pages/detail_record/detail_record_page.dart';

/// 📜 친구 상세 내역 페이지
/// - 탭으로 '내역' ↔ '프로필' 전환
class FriendsDetailHistoryPage extends ConsumerStatefulWidget {
  final String friendId;

  const FriendsDetailHistoryPage({
    super.key,
    required this.friendId,
  });

  @override
  ConsumerState<FriendsDetailHistoryPage> createState() =>
      _FriendsDetailHistoryPageState();
}

class _FriendsDetailHistoryPageState
    extends ConsumerState<FriendsDetailHistoryPage> {
  bool isHistorySelected = true;

  @override
  void initState() {
    super.initState();
    // 친구·기록 로드 (예시 userId 사용)
    const userId = 'test-user';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(friendListViewModelProvider.notifier).load(userId);
      ref
          .read(friendEventRecordViewModelProvider.notifier)
          .load(userId, widget.friendId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(friendListViewModelProvider);
    final recordState = ref.watch(friendEventRecordViewModelProvider);

    final friend =
        listState.friends.firstWhereOrNull((f) => f.id == widget.friendId);

    // 친구 정보 없으면 에러 표시
    if (friend == null) {
      return const Scaffold(
        body: Center(child: Text('친구 정보를 불러올 수 없습니다.')),
      );
    }

    // 전체/보냄/받음 레코드
    final allRecords = recordState.records;
    final sent = allRecords.where((r) => r.isSent).toList();
    final received = allRecords.where((r) => !r.isSent).toList();

    // 날짜별 그룹핑
    final Map<String, List<EventRecord>> grouped = {};
    for (final rec in allRecords) {
      final dateKey = formatFullDate(rec.date);
      grouped.putIfAbsent(dateKey, () => []).add(rec);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomSubAppBar(title: friend.name),
      body: Column(
        children: [
          const SizedBox(height: 12),
          // 내역 ↔ 프로필 토글
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RoundedToggleButton(
              leftText: '내역',
              rightText: '프로필',
              isLeftSelected: isHistorySelected,
              onToggle: (left) => setState(() => isHistorySelected = left),
            ),
          ),
          const SizedBox(height: 12),
          // 컨텐츠 스위처
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isHistorySelected
                  ? _buildHistoryView(sent, received, grouped)
                  : FriendsDetailProfilePage(friendId: friend.id),
            ),
          ),
        ],
      ),
    );
  }

  /// 내역 뷰
  Widget _buildHistoryView(
    List<EventRecord> sent,
    List<EventRecord> received,
    Map<String, List<EventRecord>> grouped,
  ) {
    return Column(
      children: [
        // 요약 박스 + 빠른기록 버튼
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '주고받은 마음',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Pretendard',
                  color: Color(0xFF2A2928),
                ),
              ),
              const SizedBox(height: 12),
              ExchangeSummaryBox(
                sentCount: sent.length,
                sentAmount: sent.fold(0, (s, r) => s + r.amount),
                receivedCount: received.length,
                receivedAmount: received.fold(0, (s, r) => s + r.amount),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '상세내역',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Pretendard',
                      color: Color(0xFF2A2928),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const QuickRecordStep1Page()),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const ThickDivider(),
        // 날짜별 내역 리스트
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: grouped.keys.length,
            itemBuilder: (_, idx) {
              final dateKey = grouped.keys.elementAt(idx);
              final items = grouped[dateKey]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 날짜 헤더
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      dateKey,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Pretendard',
                        color: Color(0xFF888580),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const ThinDivider(),
                  // 레코드 항목 반복
                  ...items.map((rec) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: EventRecordListItem(
                          record: rec,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetailRecordPage(recordId: rec.id),
                            ),
                          ),
                        ),
                      )),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
