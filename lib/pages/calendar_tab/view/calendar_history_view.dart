// 📁 lib/pages/calendar_tab/view/calendar_history_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:flutter_application_onjungapp/components/dividers/thick_divider.dart';
import 'package:flutter_application_onjungapp/components/dividers/thin_divider.dart';
import 'package:flutter_application_onjungapp/pages/calendar_tab/widgets/calendar_day_detail_item.dart';
import 'package:flutter_application_onjungapp/pages/quick_record/quick_record_step1.dart';
import 'package:flutter_application_onjungapp/components/bottom_sheet/calendar_filter_bottom_sheet.dart';
import 'package:flutter_application_onjungapp/viewmodels/calendar_tab/calendar_tab_view_model.dart';

/// 📅 내역 탭 뷰
class CalendarHistoryView extends ConsumerStatefulWidget {
  final DateTime selectedDate;
  const CalendarHistoryView({super.key, required this.selectedDate});

  @override
  ConsumerState<CalendarHistoryView> createState() =>
      _CalendarHistoryTabState();
}

class _CalendarHistoryTabState extends ConsumerState<CalendarHistoryView> {
  String _filter = '전체';

  @override
  Widget build(BuildContext context) {
    // provider 상태를 구독하면서 allItems 를 바로 꺼냅니다.
    final all = ref.watch(calendarTabViewModelProvider).allItems;
    final list = _filter == '전체'
        ? all
        : all.where((it) => it.record.eventType?.label == _filter).toList();

    // 날짜별 그룹핑
    final Map<DateTime, List<CalendarRecordItem>> grouped = {};
    for (var it in list) {
      final d = DateTime(
          it.record.date.year, it.record.date.month, it.record.date.day);
      grouped.putIfAbsent(d, () => []).add(it);
    }
    final days = grouped.keys.toList()..sort();

    return Column(
      children: [
        const SizedBox(height: 2),
        // ── 필터 + 빠른기록 ─────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  final res = await showModalBottomSheet<String>(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (_) => CalendarFilterBottomSheet(
                      initialFilter: _filter,
                    ),
                  );
                  if (res != null) setState(() => _filter = res);
                },
                child: Row(
                  children: [
                    Text(
                      '$_filter(${list.length})',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF888580),
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_drop_down, color: Color(0xFF888580)),
                  ],
                ),
              ),
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const QuickRecordStep1Page()),
                ),
                borderRadius: BorderRadius.circular(100),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.add, size: 16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const ThickDivider(),

        // ── 내역 리스트 ──────────────────────────────
        Expanded(
          child: days.isEmpty
              ? const Center(
                  child: Text(
                    '해당 월의 내역이 없습니다.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF888580),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: days.length,
                  itemBuilder: (ctx, i) {
                    final date = days[i];
                    final items = grouped[date]!;
                    final label =
                        DateFormat('yy년 M월 d일 (E)', 'ko_KR').format(date);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF888580),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        const SizedBox(height: 8),
                        const ThinDivider(hasMargin: false),
                        const SizedBox(height: 12),
                        for (var it in items) ...[
                          CalendarDayDetailItem(item: it),
                          const SizedBox(height: 16),
                        ],
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}
