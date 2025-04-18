import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/models/enums/method_type.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';
import 'package:flutter_application_onjungapp/viewmodels/calendar_tab/calendar_tab_viewmodel.dart';
import 'package:flutter_application_onjungapp/utils/input_formatters.dart';

/// 📌 캘린더 바텀시트 내 리스트 항목 위젯 (iOS 스타일 눌림 적용)
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
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails _) => setState(() => _isPressed = true);
  void _handleTapUp(TapUpDetails _) => setState(() => _isPressed = false);
  void _handleTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    final record = widget.item.record;
    final friend = widget.item.friend;

    final isSent = record.isSent;
    final amountLabel = isSent ? '보냄' : '받음';
    final amountColor =
        isSent ? const Color(0xFFD5584B) : const Color(0xFF3A77CD);

    final relationColor = friend.relation?.textColor ?? Colors.grey;
    final relationBgColor =
        friend.relation?.backgroundColor ?? const Color(0xFFE0E0E0);

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: _isPressed ? const Color(0xFFF2F2F2) : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 왼쪽 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 관계 + 이름
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: relationBgColor,
                          borderRadius: BorderRadius.circular(1000),
                        ),
                        child: Text(
                          friend.relation?.label ?? '관계 없음',
                          style: TextStyle(
                            color: relationColor,
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
                        record.eventType?.label ?? '기록 없음',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2A2928),
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text('·',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2A2928),
                          )),
                      const SizedBox(width: 4),
                      Text(
                        record.method?.label ?? '미정',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2A2928),
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 🔸 오른쪽 금액
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${formatNumberWithComma(record.amount)}원',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2A2928),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: amountLabel,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: amountColor,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
