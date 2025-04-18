// 📁 components/bottom_sheet/date_picker_bottom_sheet.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';

/// 날짜 선택 모드 정의
enum DatePickerMode {
  full, // 연/월/일 선택
  yearMonth, // 연/월만 선택
}

/// 날짜 선택 바텀시트
Future<DateTime?> showDatePickerBottomSheet({
  required BuildContext context,
  required DatePickerMode mode,
  DateTime? initialDate,
}) {
  final DateTime now = DateTime.now();
  final int currentYear = now.year;

  const int minYear = 1900;
  final int maxYear = currentYear + 5;

  DateTime tempDate = initialDate ?? now;

  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return Localizations.override(
        context: context,
        locale: const Locale('ko', 'KR'),
        child: StatefulBuilder(
          builder: (context, setModalState) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 타이틀
                Text(
                  mode == DatePickerMode.full
                      ? '보낸 날짜를 선택해 주세요'
                      : '이동할 날짜를 선택해 주세요',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Pretendard',
                  ),
                ),
                const SizedBox(height: 24),

                // 🔹 날짜 Picker
                SizedBox(
                  height: 200,
                  child: mode == DatePickerMode.full
                      ? CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: tempDate,
                          minimumDate: DateTime(minYear, 1, 1),
                          maximumDate: DateTime(maxYear, 12, 31),
                          onDateTimeChanged: (date) => tempDate = date,
                          use24hFormat: true,
                        )
                      : Row(
                          children: [
                            // 🔸 연도 Picker
                            Expanded(
                              child: CupertinoPicker(
                                scrollController: FixedExtentScrollController(
                                  initialItem: tempDate.year - minYear,
                                ),
                                itemExtent: 36,
                                onSelectedItemChanged: (index) {
                                  setModalState(() {
                                    tempDate = DateTime(
                                      minYear + index,
                                      tempDate.month,
                                    );
                                  });
                                },
                                children: [
                                  for (int year = minYear;
                                      year <= maxYear;
                                      year++)
                                    Center(child: Text('$year년')),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // 🔸 월 Picker
                            Expanded(
                              child: CupertinoPicker(
                                scrollController: FixedExtentScrollController(
                                  initialItem: tempDate.month - 1,
                                ),
                                itemExtent: 36,
                                onSelectedItemChanged: (index) {
                                  setModalState(() {
                                    tempDate = DateTime(
                                      tempDate.year,
                                      index + 1,
                                    );
                                  });
                                },
                                children: [
                                  for (int month = 1; month <= 12; month++)
                                    Center(child: Text('$month월')),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),

                const SizedBox(height: 24),

                // 🔹 확인 버튼
                BlackFillButton(
                  text: '확인',
                  onTap: () {
                    Navigator.of(context).pop(tempDate);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
