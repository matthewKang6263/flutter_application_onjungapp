// lib/components/bottom_sheet/calendar_filter_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type_filters.dart'; // 필터 상수

/// 📦 캘린더 탭 > 내역 필터 바텀시트
/// - EventTypeFilters.allOptions 로부터 옵션 불러오기
class CalendarFilterBottomSheet extends StatefulWidget {
  final String? initialFilter; // 초기 선택 필터

  const CalendarFilterBottomSheet({super.key, this.initialFilter});

  @override
  State<CalendarFilterBottomSheet> createState() =>
      _CalendarFilterBottomSheetState();
}

class _CalendarFilterBottomSheetState extends State<CalendarFilterBottomSheet> {
  late String selectedEventType;
  final List<String> eventTypes = EventTypeFilters.allOptions; // 상수에서 불러온 옵션

  @override
  void initState() {
    super.initState();
    selectedEventType = widget.initialFilter ?? EventTypeFilters.all;
  }

  Color _tileColor(String label) => selectedEventType == label
      ? const Color(0xFFC9885C)
      : const Color(0xFFF9F4EE);
  Color _textColor(String label) =>
      selectedEventType == label ? Colors.white : const Color(0xFF2A2928);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Color(0x26000000), blurRadius: 20, offset: Offset(0, -5))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('경조사',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black)),
          const SizedBox(height: 16),

          // 1열: 전체
          Row(children: [Expanded(child: _buildOption(eventTypes[0]))]),
          const SizedBox(height: 8),

          // 2열: 1~3
          Row(
              children: List.generate(3, (i) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: i == 0 ? 0 : 4, right: i == 2 ? 0 : 4),
                child: _buildOption(eventTypes[i + 1]),
              ),
            );
          })),
          const SizedBox(height: 8),

          // 3열: 4~6
          Row(
              children: List.generate(3, (i) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: i == 0 ? 0 : 4, right: i == 2 ? 0 : 4),
                child: _buildOption(eventTypes[i + 4]),
              ),
            );
          })),

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, selectedEventType),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A2928),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1000)),
              ),
              child: const Text('적용',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String label) {
    return GestureDetector(
      onTap: () => setState(() {
        selectedEventType = label;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
            color: _tileColor(label), borderRadius: BorderRadius.circular(8)),
        alignment: Alignment.center,
        child: Text(label,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _textColor(label))),
      ),
    );
  }
}
