// 📁 lib/pages/my_events_tab/widgets/my_event_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/wrappers/cupertino_touch_wrapper.dart';
import 'package:flutter_application_onjungapp/utils/date/date_formats.dart';

/// 📦 내 경조사 카드 위젯
/// - 전체 영역이 클릭 가능하며, 클릭 시 [onTap] 콜백 실행
/// - 경조사 제목, 종류, 날짜를 보여주는 카드 형태입니다.
class MyEventCard extends StatelessWidget {
  final String title; // 예: '민수&예은'
  final String eventType; // 예: '결혼식'
  final DateTime date; // 경조사 날짜
  final VoidCallback? onTap;

  const MyEventCard({
    super.key,
    required this.title,
    required this.eventType,
    required this.date,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 🔸 날짜는 "2025.04.10" 형식으로 포맷
    final String formattedDate = formatSimpleDate(date);

    return CupertinoTouchWrapper(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: ShapeDecoration(
          color: const Color(0xFFF9F4EE),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 왼쪽 텍스트 블록
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔸 제목 · 종류 표시
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: const TextStyle(
                            color: Color(0xFF2A2928),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Pretendard',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text('·',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF2A2928),
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          eventType,
                          style: const TextStyle(
                            color: Color(0xFF2A2928),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Pretendard',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // 🔸 날짜
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      color: Color(0xFF888580),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Pretendard',
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
