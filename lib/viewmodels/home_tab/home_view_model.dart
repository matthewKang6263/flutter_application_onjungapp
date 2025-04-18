// 📁 lib/viewmodels/home_tab/home_view_model.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/event_record_model.dart';
import 'package:flutter_application_onjungapp/repositories/event_record_repository.dart';

/// 🔹 보낸/받은 통계 모델
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

/// 🔹 홈 탭 ViewModel
class HomeViewModel extends ChangeNotifier {
  final EventRecordRepository _eventRepo = EventRecordRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<EventRecord> _records = [];
  List<EventRecord> get records => _records;

  ExchangeStats _stats = const ExchangeStats(
    sentCount: 0,
    sentAmount: 0,
    receivedCount: 0,
    receivedAmount: 0,
  );
  ExchangeStats get stats => _stats;

  /// 🔸 초기 데이터 로드
  Future<void> loadData(String userId) async {
    _isLoading = true;
    // notifyListeners(); ❌ 생략해도 UI에 영향 없음 (isLoading 안쓰는 구조라면)

    try {
      _records = await _eventRepo.getEventRecordsForMonth(
        userId,
        DateTime.now(), // 홈 탭은 현재 월 기준으로 요약
      );
      _stats = _calculateExchangeStats(_records);
    } catch (e) {
      print('🚨 HomeViewModel.loadData 오류: $e');
      _records = [];
      _stats = const ExchangeStats(
        sentCount: 0,
        sentAmount: 0,
        receivedCount: 0,
        receivedAmount: 0,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  /// 🔸 내부 통계 계산 로직
  ExchangeStats _calculateExchangeStats(List<EventRecord> records) {
    final sent = records.where((r) => r.isSent).toList();
    final received = records.where((r) => !r.isSent).toList();

    return ExchangeStats(
      sentCount: sent.length,
      sentAmount: sent.fold(0, (sum, r) => sum + r.amount),
      receivedCount: received.length,
      receivedAmount: received.fold(0, (sum, r) => sum + r.amount),
    );
  }
}
