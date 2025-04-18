// 📁 lib/pages/my_events_tab/my_event_detail/widgets/my_event_ledger_list_item.dart
// ✅ 전자장부 읽기 모드용 리스트 아이템
import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/tag_label.dart';
import 'package:flutter_application_onjungapp/components/wrappers/cupertino_touch_wrapper.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';

class MyEventLedgerListItem extends StatelessWidget {
  final Friend friend;
  final bool isAttending;
  final String amount; // ✅ int → String 으로 변경됨
  final VoidCallback onTap;

  const MyEventLedgerListItem({
    super.key,
    required this.friend,
    required this.isAttending,
    required this.amount,
    required this.onTap,
  });

  String _truncateName(String name) {
    return name.length <= 6 ? name : '${name.substring(0, 6)}…';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTouchWrapper(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        color: Colors.transparent,
        child: Row(
          children: [
            // 🔸 이름 + 태그
            SizedBox(
              width: 120,
              child: Row(
                children: [
                  TagLabel.fromRelationType(
                      friend.relation ?? RelationType.unset),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _truncateName(friend.name),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2A2928),
                        fontFamily: 'Pretendard',
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // 🔸 참석 여부
            Expanded(
              child: Center(
                child: Text(
                  isAttending ? '참석' : '미참석',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Pretendard',
                    color: isAttending
                        ? const Color(0xFF2A2928)
                        : const Color(0xFFB5B1AA),
                  ),
                ),
              ),
            ),

            // 🔸 금액 텍스트
            SizedBox(
              width: 90,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  amount, // ✅ 바로 포맷된 문자열 출력
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2A2928),
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
