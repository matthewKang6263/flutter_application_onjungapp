import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/bottom_sheet/calendar_day_detail_bottom_sheet.dart';
import 'package:flutter_application_onjungapp/pages/calendar_tab/widgets/calendar_day_cell.dart';
import 'package:flutter_application_onjungapp/viewmodels/calendar_tab/calendar_tab_viewmodel.dart';
import 'package:flutter_application_onjungapp/utils/calendar_utils.dart';
import 'package:provider/provider.dart';

/// 📆 캘린더 탭 메인 UI
/// - 선택한 월 기준으로 날짜 셀을 구성하고,
/// - 날짜 클릭 시 해당 날짜의 기록을 바텀시트로 표시
class CalendarView extends StatelessWidget {
  final DateTime selectedDate;

  const CalendarView({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CalendarTabViewModel>();

    final year = selectedDate.year;
    final month = selectedDate.month;
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);
    final startWeekday = firstDay.weekday % 7;
    final totalDays = lastDay.day;
    final totalCells = ((startWeekday + totalDays) / 7).ceil() * 7;

    return Column(
      children: [
        const _WeekdayHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(totalCells ~/ 7, (rowIndex) {
                return Column(
                  children: [
                    Row(
                      children: List.generate(7, (colIndex) {
                        final cellIndex = rowIndex * 7 + colIndex;
                        final day = cellIndex - startWeekday + 1;

                        if (day < 1 || day > totalDays) {
                          return const Expanded(child: SizedBox(height: 104));
                        } else {
                          final date = DateTime(year, month, day);
                          final records = vm.getRecordsForDate(date);
                          final tags = extractEventTags(records);

                          return CalendarDayCell(
                            date: date,
                            events: tags,
                            onTap: () =>
                                _openDetailSheet(context, date, records),
                          );
                        }
                      }),
                    ),
                    if (rowIndex < (totalCells ~/ 7) - 1)
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

  void _openDetailSheet(
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
    final weekdays = ['일', '월', '화', '수', '목', '금', '토'];

    return Container(
      color: const Color(0xFFF9F4EE),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: weekdays.map((label) {
          final isSunday = label == '일';
          final color =
              isSunday ? const Color(0xFFD5584B) : const Color(0xFF985F35);

          return Expanded(
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
