import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/tag_label.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';
import 'package:flutter_application_onjungapp/models/event_record_model.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/utils/input_formatters.dart';

/// 🔹 친구 리스트 아이템 위젯 (클릭 가능)
/// - 관계 태그, 이름, 최근 내역, 보냄/받음 건수 표시
/// - 클릭 시 highlight 효과 포함 (Cupertino 스타일)
class FriendListItem extends StatelessWidget {
  final Friend friend;
  final List<EventRecord> relatedRecords;
  final VoidCallback? onTap;

  const FriendListItem({
    super.key,
    required this.friend,
    required this.relatedRecords,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sentCount = relatedRecords.where((e) => e.isSent).length;
    final receivedCount = relatedRecords.where((e) => !e.isSent).length;

    final allDates = relatedRecords.map((e) => e.date).toList();
    allDates.sort((a, b) => b.compareTo(a));
    final recentDate =
        allDates.isNotEmpty ? formatDateToKorean(allDates.first) : '-';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 왼쪽: 태그 + 이름 + 최근 내역
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TagLabel.fromRelationType(
                        friend.relation ?? RelationType.unset), // ✅ 수정
                    const SizedBox(width: 4),
                    Text(
                      friend.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2A2928),
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '최근 내역: $recentDate',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFB5B1AA),
                    fontFamily: 'Pretendard',
                  ),
                ),
              ],
            ),

            /// 오른쪽: 보냄/받음 건수
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$sentCount건',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: sentCount > 0
                              ? const Color(0xFFC9885C)
                              : const Color(0xFFB5B1AA),
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      const TextSpan(
                        text: ' 보냄',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2A2928),
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$receivedCount건',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: receivedCount > 0
                              ? const Color(0xFFC9885C)
                              : const Color(0xFFB5B1AA),
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      const TextSpan(
                        text: ' 받음',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2A2928),
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
