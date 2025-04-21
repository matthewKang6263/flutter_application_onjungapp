// 📁 lib/pages/home_tab/widgets/home_stat_card.dart

import 'package:flutter/material.dart';

/// 📊 홈 탭 상단 통계 카드
/// - [title]: 예) '받은 마음', '보낸 마음'
/// - [amount]: 예) '30,000원'
class HomeStatCard extends StatelessWidget {
  final String title;
  final String amount;

  const HomeStatCard({
    Key? key,
    required this.title,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 카드 제목
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.36,
              fontFamily: 'Pretendard',
              color: Color(0xFF2A2928),
            ),
          ),
          const SizedBox(height: 4),
          // 금액
          Text(
            amount,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'Pretendard',
              color: Color(0xFFC9885C),
            ),
          ),
          // 하단 여백 (아이콘 등 추가 가능)
          const SizedBox(height: 12),
          const SizedBox(width: 153, height: 115),
        ],
      ),
    );
  }
}
