// 📁 lib/pages/calendar_tab/widgets/calendar_day_cell.dart
import 'package:flutter/material.dart';

/// 📌 달력의 하루 셀 컴포넌트
class CalendarDayCell extends StatefulWidget {
  final DateTime date;
  final List<String> events;
  final VoidCallback onTap;

  const CalendarDayCell({
    super.key,
    required this.date,
    required this.events,
    required this.onTap,
  });

  @override
  State<CalendarDayCell> createState() => _CalendarDayCellState();
}

class _CalendarDayCellState extends State<CalendarDayCell> {
  bool _pressed = false;
  void _setPressed(bool v) => setState(() => _pressed = v);

  @override
  Widget build(BuildContext context) {
    final isSunday = widget.date.weekday % 7 == 0;
    return Expanded(
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 104,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          color: _pressed ? const Color(0xFFF2F2F2) : Colors.transparent,
          child: Column(
            children: [
              Text(
                '${widget.date.day}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSunday
                      ? const Color(0xFFD5584B)
                      : const Color(0xFF888580),
                  fontFamily: 'Pretendard',
                ),
              ),
              const SizedBox(height: 4),
              // 최대 3개 이벤트 태그 표시
              ...widget.events.take(3).map((tag) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F4EE),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    tag,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF985F35),
                      fontFamily: 'Pretendard',
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
