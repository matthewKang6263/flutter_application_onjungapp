import 'package:flutter_application_onjungapp/models/event_record_model.dart';

/// 🔹 교환 통계 결과 모델
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

/// 🔹 주어진 내역 리스트에서 보낸/받은 건수 및 총 금액을 계산합니다.
/// - [isSent]가 true면 '보낸 마음', false면 '받은 마음'으로 간주합니다.
ExchangeStats calculateExchangeStats(List<EventRecord> records) {
  final sent = records.where((r) => r.isSent).toList(); // 보낸 기록만 필터링
  final received = records.where((r) => !r.isSent).toList(); // 받은 기록만 필터링

  return ExchangeStats(
    sentCount: sent.length,
    sentAmount: sent.fold(0, (sum, r) => sum + r.amount),
    receivedCount: received.length,
    receivedAmount: received.fold(0, (sum, r) => sum + r.amount),
  );
}

/// 🔹 특정 연도와 월에 해당하는 내역만 필터링하여 통계를 계산합니다.
/// - 내부적으로 [calculateExchangeStats]를 재활용합니다.
ExchangeStats calculateMonthlyExchangeStats(
    List<EventRecord> records, int year, int month) {
  final filtered = records
      .where((r) => r.date.year == year && r.date.month == month)
      .toList();
  return calculateExchangeStats(filtered);
}
