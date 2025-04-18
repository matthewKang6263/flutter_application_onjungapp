import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/utils/input_formatters.dart';

/// 🔹 주고받은 내역 요약 박스 UI 컴포넌트
/// - 보낸 건수/금액, 받은 건수/금액을 전달받아 시각적으로 표시
/// - 캘린더 탭, 친구 상세 탭 등 다양한 곳에서 재사용 가능
class ExchangeSummaryBox extends StatelessWidget {
  final int sentCount; // 총 보낸 건수
  final int sentAmount; // 총 보낸 금액
  final int receivedCount; // 총 받은 건수
  final int receivedAmount; // 총 받은 금액

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
        color: const Color(0xFFF9F4EE), // 배경색
        borderRadius: BorderRadius.circular(12), // 모서리 둥글게
      ),
      child: Column(
        children: [
          // 🔸 보낸 내역
          _buildRow('보냄', sentCount, sentAmount),

          // 🔸 중간 구분선
          const Divider(
            height: 32,
            color: Color(0xFFE0DAD1),
          ),

          // 🔸 받은 내역
          _buildRow('받음', receivedCount, receivedAmount),
        ],
      ),
    );
  }

  /// 🔸 한 줄 표시 위젯 (ex: 보냄 3건 (30,000원))
  Widget _buildRow(String label, int count, int amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 왼쪽 텍스트 (보냄 / 받음)
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2A2928),
          ),
        ),

        // 오른쪽 텍스트 (3건 (30,000원))
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$count건',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFC9885C), // 강조 색상
                  fontFamily: 'Pretendard',
                ),
              ),
              TextSpan(
                text: ' (${formatNumberWithComma(amount)}원)',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2A2928),
                  fontFamily: 'Pretendard',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
