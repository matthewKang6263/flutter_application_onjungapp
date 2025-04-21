// lib/components/bottom_sheet/events_select_bottom_sheet.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/disabled_button.dart';

/// 🔹 EventType 기반 경조사 선택 바텀시트
Future<void> showEventsSelectBottomSheet({
  required BuildContext context,
  required EventType? currentValue,
  required ValueChanged<EventType?> onSelected,
}) async {
  EventType? temp = currentValue;
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 40),
      child: StatefulBuilder(builder: (c, setSB) {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          const Align(
              alignment: Alignment.centerLeft,
              child: Text('경조사를 선택해 주세요',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Pretendard',
                      color: Colors.black))),
          const SizedBox(height: 24),
          Column(
            children: EventType.values.map((et) {
              final sel = temp == et;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setSB(() => temp = et),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(et.label,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Pretendard',
                                color: Colors.black)),
                        sel
                            ? SvgPicture.asset('assets/icons/check.svg',
                                width: 16,
                                height: 16,
                                color: const Color(0xFFC9885C))
                            : const SizedBox(width: 16, height: 16),
                      ]),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          (temp == null || temp == currentValue)
              ? const DisabledButton(text: '확인')
              : BlackFillButton(
                  text: '확인',
                  onTap: () {
                    onSelected(temp);
                    Navigator.of(context).pop();
                  },
                ),
        ]);
      }),
    ),
  );
}
