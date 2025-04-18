// 📁 lib/pages/home_tab/widgets/home_stat_card.dart

import 'package:flutter/material.dart';

/// 홈탭 상단 통계 카드 (받은 마음 / 보낸 마음)
class HomeStatCard extends StatelessWidget {
  final String title; // 카드 제목 (ex. 받은 마음)
  final String amount; // 금액 텍스트 (ex. 30,000원)

  const HomeStatCard({
    super.key,
    required this.title,
    required this.amount,
  });

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
          // 🔸 타이틀 텍스트
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

          // 🔸 금액 텍스트
          Text(
            amount,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'Pretendard',
              color: Color(0xFFC9885C),
            ),
          ),

          // 🔸 카드 하단 여백 (아이콘 등 필요 시 여기에 넣어도 됨)
          const SizedBox(height: 12),
          const SizedBox(
            width: 153,
            height: 115,
          ),
        ],
      ),
    );
  }
}
