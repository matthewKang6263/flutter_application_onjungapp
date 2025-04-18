import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/models/enums/method_type.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_onjungapp/components/box/expandable_stat_box.dart';
import 'package:flutter_application_onjungapp/utils/format_utils.dart';
import 'package:flutter_application_onjungapp/viewmodels/my_events_tab/my_event_detail_view_model.dart';

/// 📄 내 경조사 요약 탭 - 읽기 모드
/// - 받은 마음 / 참여 인원 / 화환 정보를 아코디언 박스로 표시합니다.
class MyEventSummaryReadView extends StatelessWidget {
  const MyEventSummaryReadView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MyEventDetailViewModel>();
    final event = vm.currentEvent;
    final records = vm.records;

    // 🔹 받은 기록만 필터링
    final receivedRecords = records.where((r) => !r.isSent).toList();

    // 💰 총 수금액 계산
    final totalReceivedAmount =
        receivedRecords.fold(0, (sum, r) => sum + r.amount);

    // 📦 수단별 금액 합계
    final methodGroup = <String, int>{};
    for (final r in receivedRecords) {
      final key = r.method?.label ?? '기타';
      methodGroup[key] = (methodGroup[key] ?? 0) + r.amount;
    }

    // 🧍 참석 / 미참석 인원 수
    final attendedCount = records.where((r) => r.attendance?.index == 0).length;
    final notAttendedCount = records.length - attendedCount;

    // 📅 날짜 포맷
    final dateText = formatShortFullDate(event.date);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔸 상단 안내 문구
          Text(
            '$dateText\n${event.title} ${event.eventType.label}에서\n받은 마음은 아래와 같아요',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2A2928),
              height: 1.36,
              fontFamily: 'Pretendard',
            ),
          ),
          const SizedBox(height: 32),

          // 🔸 받은 마음 통계
          ExpandableStatBox(
            title: '받은 마음',
            total: formatCurrency(totalReceivedAmount),
            details: methodGroup.map(
              (k, v) => MapEntry(k, formatCurrency(v)),
            ),
          ),
          const SizedBox(height: 12),

          // 🔸 참여 인원 통계
          ExpandableStatBox(
            title: '참여 인원',
            total: '${records.length}명',
            details: {
              '참석 인원': '$attendedCount명',
              '미참석 인원': '$notAttendedCount명',
            },
          ),
          const SizedBox(height: 12),

          // 🔸 화환 목록
          ExpandableStatBox(
            title: '화환',
            total: '${event.flowerFriendNames.length}개',
            details: {
              for (int i = 0; i < event.flowerFriendNames.length; i++)
                '친구 ${i + 1}': event.flowerFriendNames[i],
            },
          ),
        ],
      ),
    );
  }
}
