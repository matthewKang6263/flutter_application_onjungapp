import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/models/enums/method_type.dart';
import 'package:flutter_application_onjungapp/models/event_record_model.dart';
import 'package:flutter_application_onjungapp/utils/input_formatters.dart';

/// 🔹 경조사 내역 리스트 항목 위젯
/// - 종류 + 수단 + 금액 + 보냄/받음 표시
class EventRecordListItem extends StatefulWidget {
  final EventRecord record;
  final VoidCallback? onTap;

  const EventRecordListItem({
    super.key,
    required this.record,
    this.onTap,
  });

  @override
  State<EventRecordListItem> createState() => _EventRecordListItemState();
}

class _EventRecordListItemState extends State<EventRecordListItem> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails _) => setState(() => _isPressed = true);
  void _handleTapUp(TapUpDetails _) => setState(() => _isPressed = false);
  void _handleTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    final record = widget.record;
    final isSent = record.isSent;
    final label = isSent ? '보냄' : '받음';
    final color = isSent ? const Color(0xFFD5584B) : const Color(0xFF3A77CD);

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: _isPressed
            ? const Color(0xFFF2F2F2)
            : Colors.transparent, // iOS 스타일 눌림색
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 🔹 왼쪽 정보
            Row(
              children: [
                Text(
                  record.eventType?.label ?? '-',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2A2928),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF5E8),
                    borderRadius: BorderRadius.circular(1000),
                  ),
                  child: Text(
                    record.method?.label ?? '-',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFC9885C),
                    ),
                  ),
                ),
              ],
            ),

            // 🔸 오른쪽 정보
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${formatNumberWithComma(record.amount)}원 ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2A2928),
                    ),
                  ),
                  TextSpan(
                    text: label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
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
