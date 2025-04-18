import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type_filters.dart'; // ✅ 필터 상수 불러오기

/// 📦 캘린더 탭 > 내역 필터 바텀시트
/// - 경조사 항목 선택 UI (시안 기반)
class CalendarFilterBottomSheet extends StatefulWidget {
  final String? initialFilter;

  const CalendarFilterBottomSheet({super.key, this.initialFilter});

  @override
  State<CalendarFilterBottomSheet> createState() =>
      _CalendarFilterBottomSheetState();
}

class _CalendarFilterBottomSheetState extends State<CalendarFilterBottomSheet> {
  late String selectedEventType;

  // ✅ 기존 수동 리스트 → 상수 클래스 사용
  final List<String> eventTypes = EventTypeFilters.allOptions;

  @override
  void initState() {
    super.initState();
    selectedEventType = widget.initialFilter ?? EventTypeFilters.all;
  }

  Color getTileColor(String label) {
    return selectedEventType == label
        ? const Color(0xFFC9885C)
        : const Color(0xFFF9F4EE);
  }

  Color getTextColor(String label) {
    return selectedEventType == label ? Colors.white : const Color(0xFF2A2928);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 20,
            offset: Offset(0, -5),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '경조사',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          // 🔸 필터 UI: 시안 레이아웃 유지
          Column(
            children: [
              Row(children: [Expanded(child: _buildOption(eventTypes[0]))]),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (int i = 1; i <= 3; i++)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: i == 1 ? 0 : 4,
                          right: i == 3 ? 0 : 4,
                        ),
                        child: _buildOption(eventTypes[i]),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (int i = 4; i <= 6; i++)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: i == 4 ? 0 : 4,
                          right: i == 6 ? 0 : 4,
                        ),
                        child: _buildOption(eventTypes[i]),
                      ),
                    ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedEventType);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A2928),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1000),
                ),
              ),
              child: const Text(
                '적용',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String label) {
    return GestureDetector(
      onTap: () => setState(() => selectedEventType = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: getTileColor(label),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: getTextColor(label),
          ),
        ),
      ),
    );
  }
}
