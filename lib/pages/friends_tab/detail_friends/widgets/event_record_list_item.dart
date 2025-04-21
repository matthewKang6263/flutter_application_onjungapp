// 📁 lib/pages/friends_tab/detail_friends/widgets/event_record_list_item.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/models/enums/method_type.dart';
import 'package:flutter_application_onjungapp/models/event_record_model.dart';
import 'package:flutter_application_onjungapp/utils/number_formats.dart';

/// 💬 경조사 내역 리스트 아이템
/// - [record]: 단일 EventRecord 데이터
/// - [onTap]: 클릭 시 상세 페이지 이동
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
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final rec = widget.record;
    final isSent = rec.isSent;
    final label = isSent ? '보냄' : '받음';
    final color = isSent ? const Color(0xFFD5584B) : const Color(0xFF3A77CD);

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: _pressed ? const Color(0xFFF2F2F2) : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ── 왼쪽: 경조사 종류 + 수단
            Row(
              children: [
                Text(
                  rec.eventType?.label ?? '-',
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
                    rec.method?.label ?? '-',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFC9885C),
                    ),
                  ),
                ),
              ],
            ),
            // ── 오른쪽: 금액 + 보냄/받음
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: '${formatNumberWithComma(rec.amount)}원 ',
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
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
