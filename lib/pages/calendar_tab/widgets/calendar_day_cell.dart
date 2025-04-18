// 📁 lib/pages/calendar_tab/widgets/calendar_day_cell.dart

import 'package:flutter/material.dart';

/// 📌 달력 날짜 셀 컴포넌트
/// - 날짜 숫자 + 태그(최대 3개) 표시
/// - iOS 스타일 눌림 효과 적용
/// - 클릭 시 상세 보기 콜백 실행
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
  bool _isPressed = false;

  /// 🔹 누를 때 배경색 전환용 핸들러
  void _handleTapDown(TapDownDetails _) => setState(() => _isPressed = true);
  void _handleTapUp(TapUpDetails _) => setState(() => _isPressed = false);
  void _handleTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    // 🔸 일요일 여부 확인 (Flutter: 일요일은 weekday == 7)
    final isSunday = widget.date.weekday % 7 == 0;
    final day = widget.date.day;

    return Expanded(
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 104,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          color: _isPressed
              ? const Color(0xFFF2F2F2)
              : Colors.transparent, // 🔹 눌림 배경 (iOS 스타일)
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔸 날짜 숫자 표시
              Text(
                '$day',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSunday
                      ? const Color(0xFFD5584B) // 🔹 일요일은 빨간색
                      : const Color(0xFF888580), // 🔹 기본 회색
                  fontFamily: 'Pretendard',
                ),
              ),
              const SizedBox(height: 4),

              // 🔸 태그 리스트 (최대 3개, 줄바꿈 없이 수직 정렬)
              ...widget.events.map(
                (tag) => Container(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
