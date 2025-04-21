import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/utils/date/date_formats.dart';
import 'package:flutter_application_onjungapp/utils/number_formats.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/components/box/expandable_stat_box.dart';
import 'package:flutter_application_onjungapp/viewmodels/my_events_tab/my_event_detail_view_model.dart';
import 'package:flutter_application_onjungapp/models/enums/method_type.dart';
import 'package:flutter_application_onjungapp/models/my_event_model.dart';

class MyEventSummaryReadView extends ConsumerWidget {
  final MyEvent event;

  const MyEventSummaryReadView({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myEventDetailViewModelProvider(event));
    final eventData = state.event!;
    final records = state.records;

    final receivedRecords = records.where((r) => !r.isSent).toList();
    final totalReceivedAmount =
        receivedRecords.fold(0, (sum, r) => sum + r.amount);

    final methodGroup = <String, int>{};
    for (final r in receivedRecords) {
      final key = r.method?.label ?? '기타';
      methodGroup[key] = (methodGroup[key] ?? 0) + r.amount;
    }

    final attendedCount = records.where((r) => r.attendance?.index == 0).length;
    final notAttendedCount = records.length - attendedCount;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${formatShortFullDate(eventData.date)}\n${eventData.title} ${eventData.eventType.label}에서\n받은 마음은 아래와 같아요',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2A2928),
              height: 1.36,
              fontFamily: 'Pretendard',
            ),
          ),
          const SizedBox(height: 32),
          ExpandableStatBox(
            title: '받은 마음',
            total: formatNumberWithComma(totalReceivedAmount),
            details: methodGroup.map(
              (k, v) => MapEntry(k, formatNumberWithComma(v)),
            ),
          ),
          const SizedBox(height: 12),
          ExpandableStatBox(
            title: '참여 인원',
            total: '${records.length}명',
            details: {
              '참석 인원': '$attendedCount명',
              '미참석 인원': '$notAttendedCount명',
            },
          ),
          const SizedBox(height: 12),
          ExpandableStatBox(
            title: '화환',
            total: '${eventData.flowerFriendNames.length}개',
            details: {
              for (int i = 0; i < eventData.flowerFriendNames.length; i++)
                '친구 ${i + 1}': eventData.flowerFriendNames[i],
            },
          ),
        ],
      ),
    );
  }
}
