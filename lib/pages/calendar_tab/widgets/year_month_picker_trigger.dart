import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 📅 연/월 선택용 트리거 위젯
class YearMonthPickerTrigger extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onTap;

  const YearMonthPickerTrigger({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // intl 패키지로 "2025년 4월" 형식으로 포맷
    final label = DateFormat.yMMM('ko').format(selectedDate);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              fontFamily: 'Pretendard',
              color: Color(0xFF2A2928),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down, color: Color(0xFF2A2928)),
        ],
      ),
    );
  }
}
