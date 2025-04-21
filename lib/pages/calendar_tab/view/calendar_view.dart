// 📁 lib/pages/calendar_tab/view/calendar_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/utils/tag_extractor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/components/bottom_sheet/calendar_day_detail_bottom_sheet.dart';
import 'package:flutter_application_onjungapp/viewmodels/calendar_tab/calendar_tab_view_model.dart';
import 'package:flutter_application_onjungapp/pages/calendar_tab/widgets/calendar_day_cell.dart';

/// 📆 달력 뷰
class CalendarView extends ConsumerWidget {
  final DateTime selectedDate;
  const CalendarView({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(calendarTabViewModelProvider.notifier);

    final year = selectedDate.year;
    final month = selectedDate.month;
    final first = DateTime(year, month, 1);
    final last = DateTime(year, month + 1, 0);
    final startEmpty = first.weekday % 7;
    final days = last.day;
    final totalCells = ((startEmpty + days) / 7).ceil() * 7;

    return Column(
      children: [
        const _WeekdayHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(totalCells ~/ 7, (row) {
                return Column(
                  children: [
                    Row(
                      children: List.generate(7, (col) {
                        final idx = row * 7 + col;
                        final day = idx - startEmpty + 1;
                        if (day < 1 || day > days) {
                          return const Expanded(child: SizedBox(height: 104));
                        }
                        final date = DateTime(year, month, day);
                        final items = vm.getRecordsForDate(date);
                        final tags = extractEventTags(items);
                        return CalendarDayCell(
                          date: date,
                          events: tags,
                          onTap: () => _openDetail(context, date, items),
                        );
                      }),
                    ),
                    if (row < (totalCells ~/ 7) - 1)
                      const Divider(height: 1, color: Color(0xFFE8E8E6)),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  void _openDetail(
    BuildContext context,
    DateTime date,
    List<CalendarRecordItem> items,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => CalendarDayDetailBottomSheet(
        date: date,
        items: items,
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader();
  @override
  Widget build(BuildContext context) {
    const days = ['일', '월', '화', '수', '목', '금', '토'];
    return Container(
      color: const Color(0xFFF9F4EE),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: days.map((d) {
          final isSun = d == '일';
          return Expanded(
            child: Center(
              child: Text(
                d,
                style: TextStyle(
                  color:
                      isSun ? const Color(0xFFD5584B) : const Color(0xFF985F35),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
