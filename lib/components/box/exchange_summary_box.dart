// lib/components/box/exchange_summary_box.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/utils/number_formats.dart'; // formatNumberWithComma

/// 🔹 주고받은 내역 요약 박스
/// - 보낸/받은 건수 및 금액을 표시
class ExchangeSummaryBox extends StatelessWidget {
  final int sentCount; // 보낸 건수
  final int sentAmount; // 보낸 총액
  final int receivedCount; // 받은 건수
  final int receivedAmount; // 받은 총액

  const ExchangeSummaryBox({
    super.key,
    required this.sentCount,
    required this.sentAmount,
    required this.receivedCount,
    required this.receivedAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F4EE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildRow('보냄', sentCount, sentAmount),
          const Divider(height: 32, color: Color(0xFFE0DAD1)),
          _buildRow('받음', receivedCount, receivedAmount),
        ],
      ),
    );
  }

  /// ● 한 줄 레이아웃
  Widget _buildRow(String label, int count, int amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2A2928)),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$count건',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFC9885C),
                    fontFamily: 'Pretendard'),
              ),
              TextSpan(
                text: ' (${formatNumberWithComma(amount)}원)',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2A2928),
                    fontFamily: 'Pretendard'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
