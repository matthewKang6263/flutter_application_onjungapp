// lib/components/bottom_sheet/date_picker_bottom_sheet.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';

/// 🔹 날짜 선택 모드
enum DatePickerMode { full, yearMonth }

/// 🔹 날짜 선택 바텀시트
Future<DateTime?> showDatePickerBottomSheet({
  required BuildContext context,
  required DatePickerMode mode,
  DateTime? initialDate,
}) {
  final now = DateTime.now();
  const minYear = 1900;
  final maxYear = now.year + 5;
  DateTime tempDate = initialDate ?? now;

  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => Localizations.override(
      context: context,
      locale: const Locale('ko', 'KR'),
      child: StatefulBuilder(
        builder: (context, setStateModal) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 40),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mode == DatePickerMode.full
                      ? '보낸 날짜를 선택해 주세요'
                      : '이동할 날짜를 선택해 주세요',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Pretendard'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 200,
                  child: mode == DatePickerMode.full
                      ? CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: tempDate,
                          minimumDate: DateTime(minYear),
                          maximumDate: DateTime(maxYear, 12, 31),
                          onDateTimeChanged: (d) => tempDate = d,
                          use24hFormat: true,
                        )
                      : Row(
                          children: [
                            // 연도
                            Expanded(
                              child: CupertinoPicker(
                                scrollController: FixedExtentScrollController(
                                    initialItem: tempDate.year - minYear),
                                itemExtent: 36,
                                onSelectedItemChanged: (i) => setStateModal(
                                    () => tempDate =
                                        DateTime(minYear + i, tempDate.month)),
                                children: [
                                  for (var y = minYear; y <= maxYear; y++)
                                    Center(child: Text('$y년'))
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // 월
                            Expanded(
                              child: CupertinoPicker(
                                scrollController: FixedExtentScrollController(
                                    initialItem: tempDate.month - 1),
                                itemExtent: 36,
                                onSelectedItemChanged: (i) => setStateModal(
                                    () => tempDate =
                                        DateTime(tempDate.year, i + 1)),
                                children: [
                                  for (var m = 1; m <= 12; m++)
                                    Center(child: Text('$m월'))
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 24),
                BlackFillButton(
                  text: '확인',
                  onTap: () => Navigator.of(context).pop(tempDate),
                ),
              ]),
        ),
      ),
    ),
  );
}
