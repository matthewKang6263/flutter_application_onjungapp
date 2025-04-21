// 📁 lib/pages/calendar_tab/widgets/calendar_day_detail_bottom_sheet.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/dividers/thin_divider.dart';
import 'package:flutter_application_onjungapp/pages/detail_record/detail_record_page.dart';
import 'package:flutter_application_onjungapp/pages/quick_record/quick_record_step1.dart';
import 'package:flutter_application_onjungapp/pages/calendar_tab/widgets/calendar_day_detail_item.dart';
import 'package:flutter_application_onjungapp/viewmodels/calendar_tab/calendar_tab_view_model.dart';

/// 📌 캘린더 날짜 선택 시 표시되는 바텀시트
/// - 선택한 날짜에 해당하는 경조사 내역 리스트 출력
class CalendarDayDetailBottomSheet extends StatelessWidget {
  final DateTime date;
  final List<CalendarRecordItem> items;

  const CalendarDayDetailBottomSheet({
    super.key,
    required this.date,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('yy년 M월 d일 (E)', 'ko').format(date);

    return Container(
      height: 550,
      padding: const EdgeInsets.only(top: 32, bottom: 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ 타이틀 + 추가 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateLabel,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'Pretendard',
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QuickRecordStep1Page(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(100),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SvgPicture.asset(
                      'assets/icons/add.svg',
                      width: 16,
                      height: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ✅ 디바이더
          if (items.isNotEmpty) const ThinDivider(),
          const SizedBox(height: 8),

          // ✅ 내역 리스트
          Expanded(
            child: items.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return CalendarDayDetailItem(
                        item: item,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailRecordPage(
                                recordId: item.record.id, // ✅ ✅ 핵심 변경
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                : const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 160),
                      child: Text(
                        '내역이 존재하지 않아요',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF888580),
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ),
                  ),
          ),

          const SizedBox(height: 16),

          // ✅ 하단 확인 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlackFillButton(
              text: '확인',
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
