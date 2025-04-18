// 📁 components/bottom_sheet/events_select_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/disabled_button.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';

/// 경조사 종류 선택 바텀시트 (EventType 기반)
Future<void> showEventsSelectBottomSheet({
  required BuildContext context,
  required EventType? currentValue, // 현재 선택된 값
  required ValueChanged<EventType?> onSelected, // 선택 후 콜백
}) async {
  EventType? tempSelected = currentValue;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 40),
        child: StatefulBuilder(
          builder: (context, setModalState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '경조사를 선택해 주세요',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Pretendard',
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 🔹 항목 리스트 (Enum 활용)
                Column(
                  children: EventType.values.map((type) {
                    final isSelected = tempSelected == type;
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setModalState(() => tempSelected = type),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              type.label,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Pretendard',
                                color: Colors.black,
                              ),
                            ),
                            isSelected
                                ? SvgPicture.asset(
                                    'assets/icons/check.svg',
                                    width: 16,
                                    height: 16,
                                    color: const Color(0xFFC9885C),
                                  )
                                : const SizedBox(width: 16, height: 16),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // 🔹 확인 버튼
                (tempSelected == null || tempSelected == currentValue)
                    ? const DisabledButton(text: '확인')
                    : BlackFillButton(
                        text: '확인',
                        onTap: () {
                          onSelected(tempSelected);
                          Navigator.of(context).pop();
                        },
                      ),
              ],
            );
          },
        ),
      );
    },
  );
}
