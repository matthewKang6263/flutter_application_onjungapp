// 📁 lib/viewmodels/home_tab/home_view_model.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/models/event_record_model.dart';
import 'package:flutter_application_onjungapp/repositories/event_record_repository.dart';

/// 🔹 보낸/받은 통계
class ExchangeStats {
  final int sentCount, sentAmount, receivedCount, receivedAmount;
  const ExchangeStats(
      {required this.sentCount,
      required this.sentAmount,
      required this.receivedCount,
      required this.receivedAmount});
  factory ExchangeStats.empty() => const ExchangeStats(
      sentCount: 0, sentAmount: 0, receivedCount: 0, receivedAmount: 0);
}

/// 🔹 Home 탭 상태
class HomeState {
  final bool isLoading;
  final List<EventRecord> records;
  final ExchangeStats stats;
  const HomeState(
      {required this.isLoading, required this.records, required this.stats});
  factory HomeState.initial() =>
      HomeState(isLoading: false, records: [], stats: ExchangeStats.empty());
  HomeState copyWith(
          {bool? isLoading,
          List<EventRecord>? records,
          ExchangeStats? stats}) =>
      HomeState(
        isLoading: isLoading ?? this.isLoading,
        records: records ?? this.records,
        stats: stats ?? this.stats,
      );
}

/// 🔹 Home 뷰모델
class HomeViewModel extends Notifier<HomeState> {
  final _repo = EventRecordRepository();
  @override
  HomeState build() => HomeState.initial();

  /// ● 현재 월 데이터 로드
  Future<void> loadData(String userId) async {
    state = state.copyWith(isLoading: true);
    try {
      final recs = await _repo.getByMonth(userId, DateTime.now());
      final stats = _calculateStats(recs);
      state = state.copyWith(records: recs, stats: stats, isLoading: false);
    } catch (e) {
      debugPrint('🚨 Home 데이터 로드 실패: $e');
      state = state.copyWith(
          records: [], stats: ExchangeStats.empty(), isLoading: false);
    }
  }

  /// ● 통계 계산
  ExchangeStats _calculateStats(List<EventRecord> recs) {
    final sent = recs.where((r) => r.isSent);
    final recv = recs.where((r) => !r.isSent);
    return ExchangeStats(
      sentCount: sent.length,
      sentAmount: sent.fold(0, (sum, r) => sum + r.amount),
      receivedCount: recv.length,
      receivedAmount: recv.fold(0, (sum, r) => sum + r.amount),
    );
  }
}

/// 🔹 Provider
final homeViewModelProvider =
    NotifierProvider<HomeViewModel, HomeState>(HomeViewModel.new);
