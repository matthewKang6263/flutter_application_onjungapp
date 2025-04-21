// 📁 lib/pages/calendar_tab/widgets/calendar_day_detail_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/models/enums/method_type.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_onjungapp/viewmodels/calendar_tab/calendar_tab_view_model.dart';

/// 📌 하루 상세 내역 아이템
class CalendarDayDetailItem extends StatefulWidget {
  final CalendarRecordItem item;
  final VoidCallback? onTap;

  const CalendarDayDetailItem({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  State<CalendarDayDetailItem> createState() => _CalendarDayDetailItemState();
}

class _CalendarDayDetailItemState extends State<CalendarDayDetailItem> {
  bool _pressed = false;

  void _setPressed(bool v) => setState(() => _pressed = v);

  @override
  Widget build(BuildContext context) {
    final rec = widget.item.record;
    final friend = widget.item.friend;
    final isSent = rec.isSent;
    final amtColor = isSent ? const Color(0xFFD5584B) : const Color(0xFF3A77CD);
    final amtLabel = isSent ? '보냄' : '받음';

    // intl로 천 단위 콤마 포맷
    final formattedAmt = NumberFormat.decimalPattern('ko').format(rec.amount);

    // 관계 태그 색상
    final relBg = friend.relation?.backgroundColor ?? Colors.grey.shade200;
    final relFg = friend.relation?.textColor ?? Colors.black;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: _pressed ? const Color(0xFFF2F2F2) : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // ─ 왼쪽: 관계 + 이름 + 이벤트/수단
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: relBg,
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        child: Text(
                          friend.relation?.label ?? '미정',
                          style: TextStyle(
                            color: relFg,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        friend.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2A2928),
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        rec.eventType?.label ?? '-',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2A2928),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text('·'),
                      const SizedBox(width: 4),
                      Text(
                        rec.method?.label ?? '-',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2A2928),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // ─ 오른쪽: 금액 + 보냄/받음
            Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: '$formattedAmt원',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2A2928),
                  ),
                ),
                const TextSpan(text: ' '),
                TextSpan(
                  text: amtLabel,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: amtColor,
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
