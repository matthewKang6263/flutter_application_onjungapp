// lib/utils/exchange_stats.dart

import 'package:flutter_application_onjungapp/models/event_record_model.dart';

/// 🔹 교환 통계 결과 모델
/// - sentCount: 보낸 건수
/// - sentAmount: 보낸 총액
/// - receivedCount: 받은 건수
/// - receivedAmount: 받은 총액
class ExchangeStats {
  final int sentCount;
  final int sentAmount;
  final int receivedCount;
  final int receivedAmount;

  const ExchangeStats({
    required this.sentCount,
    required this.sentAmount,
    required this.receivedCount,
    required this.receivedAmount,
  });
}

/// 🔹 전체 내역 리스트에서 보내기/받기 통계 계산
/// - [records]: EventRecord 리스트
/// - isSent=true인 항목은 보낸 마음, false는 받은 마음으로 집계
ExchangeStats calculateExchangeStats(List<EventRecord> records) {
  final sent = records.where((r) => r.isSent).toList();
  final received = records.where((r) => !r.isSent).toList();

  return ExchangeStats(
    sentCount: sent.length,
    sentAmount: sent.fold(0, (sum, r) => sum + r.amount),
    receivedCount: received.length,
    receivedAmount: received.fold(0, (sum, r) => sum + r.amount),
  );
}

/// 🔹 특정 연도·월 기준으로 필터 후 통계 계산
ExchangeStats calculateMonthlyExchangeStats(
  List<EventRecord> records,
  int year,
  int month,
) {
  final filtered = records
      .where((r) => r.date.year == year && r.date.month == month)
      .toList();
  return calculateExchangeStats(filtered);
}
