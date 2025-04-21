// 📁 lib/viewmodels/calendar_tab/calendar_tab_viewmodel.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/models/event_record_model.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/repositories/event_record_repository.dart';
import 'package:flutter_application_onjungapp/repositories/friend_repository.dart';

/// 🔹 캘린더 탭 상태
class CalendarState {
  final bool isLoading;
  final List<CalendarRecordItem> allItems;
  final DateTime? currentMonth;
  final String? userId;

  const CalendarState({
    this.isLoading = false,
    this.allItems = const [],
    this.currentMonth,
    this.userId,
  });

  CalendarState copyWith({
    bool? isLoading,
    List<CalendarRecordItem>? allItems,
    DateTime? currentMonth,
    String? userId,
  }) =>
      CalendarState(
        isLoading: isLoading ?? this.isLoading,
        allItems: allItems ?? this.allItems,
        currentMonth: currentMonth ?? this.currentMonth,
        userId: userId ?? this.userId,
      );
}

/// 🔹 단일 캘린더 항목 (레코드+친구)
class CalendarRecordItem {
  final EventRecord record;
  final Friend friend;
  CalendarRecordItem({required this.record, required this.friend});
}

/// 🔹 교환 요약 모델
class CalendarExchangeSummary {
  final int sentCount, sentAmount, receivedCount, receivedAmount;
  CalendarExchangeSummary({
    required this.sentCount,
    required this.sentAmount,
    required this.receivedCount,
    required this.receivedAmount,
  });
}

/// 🔹 캘린더 뷰모델
class CalendarTabViewModel extends Notifier<CalendarState> {
  final _recordRepo = EventRecordRepository();
  final _friendRepo = FriendRepository();

  @override
  CalendarState build() => const CalendarState();

  /// ● 월별 기록 & 친구 로드
  Future<void> loadRecords(String userId, DateTime month) async {
    state =
        state.copyWith(isLoading: true, userId: userId, currentMonth: month);
    try {
      final friends = await _friendRepo.getAll(userId);
      final records = await _recordRepo.getByMonth(userId, month);
      final items = records.map((r) {
        final f = friends.firstWhere((f) => f.id == r.friendId);
        return CalendarRecordItem(record: r, friend: f);
      }).toList();
      state = state.copyWith(allItems: items, isLoading: false);
    } catch (e) {
      debugPrint('🚨 캘린더 로드 실패: $e');
      state = state.copyWith(allItems: [], isLoading: false);
    }
  }

  /// ● 특정 날짜 내역
  List<CalendarRecordItem> getRecordsForDate(DateTime date) =>
      state.allItems.where((it) {
        final d = it.record.date;
        return d.year == date.year &&
            d.month == date.month &&
            d.day == date.day;
      }).toList();

  /// ● 월별 요약 계산
  CalendarExchangeSummary getSummaryForMonth() {
    final sent = state.allItems.where((it) => it.record.isSent);
    final recv = state.allItems.where((it) => !it.record.isSent);
    return CalendarExchangeSummary(
      sentCount: sent.length,
      sentAmount: sent.fold(0, (s, it) => s + it.record.amount),
      receivedCount: recv.length,
      receivedAmount: recv.fold(0, (s, it) => s + it.record.amount),
    );
  }
}

/// 🔹 Provider
final calendarTabViewModelProvider =
    NotifierProvider<CalendarTabViewModel, CalendarState>(
        CalendarTabViewModel.new);
