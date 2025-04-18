import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:flutter_application_onjungapp/components/bottom_sheet/calendar_filter_bottom_sheet.dart';
import 'package:flutter_application_onjungapp/components/dividers/thick_divider.dart';
import 'package:flutter_application_onjungapp/components/dividers/thin_divider.dart';
import 'package:flutter_application_onjungapp/models/enums/attendance_type.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type_filters.dart';
import 'package:flutter_application_onjungapp/models/enums/method_type.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';
import 'package:flutter_application_onjungapp/pages/calendar_tab/widgets/calendar_day_detail_item.dart';
import 'package:flutter_application_onjungapp/pages/detail_record/detail_record_page.dart';
import 'package:flutter_application_onjungapp/pages/quick_record/quick_record_step1.dart';
import 'package:flutter_application_onjungapp/utils/input_formatters.dart';
import 'package:flutter_application_onjungapp/viewmodels/calendar_tab/calendar_tab_viewmodel.dart';
import 'package:provider/provider.dart';

/// 📅 캘린더 > 내역 탭
class CalendarHistoryView extends StatefulWidget {
  final DateTime selectedDate;

  const CalendarHistoryView({super.key, required this.selectedDate});

  @override
  State<CalendarHistoryView> createState() => _CalendarHistoryTabState();
}

class _CalendarHistoryTabState extends State<CalendarHistoryView> {
  String selectedEventType = EventTypeFilters.all;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalendarTabViewModel>();

    final allItems = viewModel.getRecordsForMonth();
    final filteredItems = selectedEventType == EventTypeFilters.all
        ? allItems
        : allItems
            .where((item) => item.record.eventType?.label == selectedEventType)
            .toList();

    final groupedItems = _groupItemsByDate(filteredItems);

    return Column(
      children: [
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  final result = await showModalBottomSheet<String>(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (_) => CalendarFilterBottomSheet(
                      initialFilter: selectedEventType,
                    ),
                  );
                  if (result != null) {
                    setState(() => selectedEventType = result);
                  }
                },
                child: Row(
                  children: [
                    Text(
                      '$selectedEventType(${filteredItems.length})',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF888580),
                      ),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      'assets/icons/dropdown_arrow.svg',
                      width: 16,
                      height: 16,
                      color: Color(0xFF888580),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const QuickRecordStep1Page(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(100),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    'assets/icons/add.svg',
                    width: 16,
                    height: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const ThickDivider(),
        Expanded(
          child: groupedItems.isEmpty
              ? const _EmptyHistory()
              : ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: groupedItems.entries.map((entry) {
                    final date = entry.key;
                    final records = entry.value;

                    return _buildDateGroup(date, records);
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildDateGroup(DateTime date, List<CalendarRecordItem> items) {
    final dateLabel = DateFormat('yy년 M월 d일 (E)', 'ko_KR').format(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          dateLabel,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF888580),
          ),
        ),
        const SizedBox(height: 8),
        const ThinDivider(hasMargin: false),
        const SizedBox(height: 12),
        ...items.map((item) => Column(
              children: [
                CalendarDayDetailItem(
                  item: item,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailRecordPage(
                          name: item.friend.name,
                          relation: item.friend.relation?.label ?? '',
                          amount: formatNumberWithComma(item.record.amount),
                          direction: item.record.isSent ? '보냄' : '받음',
                          eventType: item.record.eventType?.label ?? '',
                          date: DateFormat('yyyy년 M월 d일 (E)', 'ko_KR')
                              .format(item.record.date),
                          method: item.record.method?.label ?? '',
                          attendance: item.record.attendance?.label ?? '',
                          memo: item.record.memo ?? '',
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            )),
      ],
    );
  }

  Map<DateTime, List<CalendarRecordItem>> _groupItemsByDate(
      List<CalendarRecordItem> items) {
    final Map<DateTime, List<CalendarRecordItem>> grouped = {};

    for (final item in items) {
      final recordDate = DateTime(
        item.record.date.year,
        item.record.date.month,
        item.record.date.day,
      );
      grouped.putIfAbsent(recordDate, () => []).add(item);
    }

    final sortedKeys = grouped.keys.toList()..sort();
    return {
      for (final key in sortedKeys) key: grouped[key]!,
    };
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '해당 월의 내역이 없습니다.',
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF888580),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
