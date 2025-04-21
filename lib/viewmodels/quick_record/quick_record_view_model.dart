// 📁 lib/viewmodels/quick_record/quick_record_view_model.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/models/event_record_model.dart';
import 'package:flutter_application_onjungapp/repositories/event_record_repository.dart';
import 'package:flutter_application_onjungapp/models/enums/method_type.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/models/enums/attendance_type.dart';

/// 🔹 QuickRecord 상태
class QuickRecordState {
  final bool isSend;
  final Friend? selectedFriend;
  final int amount;
  final MethodType? method;
  final EventType? eventType;
  final DateTime? date;
  final AttendanceType? attendance;
  final String memo;

  const QuickRecordState({
    required this.isSend,
    this.selectedFriend,
    this.amount = 0,
    this.method,
    this.eventType,
    this.date,
    this.attendance,
    this.memo = '',
  });

  QuickRecordState copyWith({
    bool? isSend,
    Friend? selectedFriend,
    int? amount,
    MethodType? method,
    EventType? eventType,
    DateTime? date,
    AttendanceType? attendance,
    String? memo,
  }) =>
      QuickRecordState(
        isSend: isSend ?? this.isSend,
        selectedFriend: selectedFriend ?? this.selectedFriend,
        amount: amount ?? this.amount,
        method: method ?? this.method,
        eventType: eventType ?? this.eventType,
        date: date ?? this.date,
        attendance: attendance ?? this.attendance,
        memo: memo ?? this.memo,
      );

  factory QuickRecordState.initial() => const QuickRecordState(isSend: true);
}

/// 🔹 QuickRecord 뷰모델
class QuickRecordViewModel extends Notifier<QuickRecordState> {
  final _repo = EventRecordRepository();
  @override
  QuickRecordState build() => QuickRecordState.initial();

  // Step1~3 상태 변경 메서드
  void toggleIsSend(bool v) => state = state.copyWith(isSend: v);
  void selectFriend(Friend f) => state = state.copyWith(selectedFriend: f);
  void clearFriend() => state = state.copyWith(selectedFriend: null);
  void setAmount(int v) => state = state.copyWith(amount: v);
  void addAmount(int v) => state = state.copyWith(amount: state.amount + v);
  void selectMethod(MethodType? m) => state = state.copyWith(method: m);
  void selectEventType(EventType? et) => state = state.copyWith(eventType: et);
  void selectDate(DateTime? d) => state = state.copyWith(date: d);
  void selectAttendance(AttendanceType? a) =>
      state = state.copyWith(attendance: a);
  void updateMemo(String m) => state = state.copyWith(memo: m);
  void clearMemo() => state = state.copyWith(memo: '');

  /// ● 레코드 저장
  Future<void> submit(String userId) async {
    final s = state;
    if (s.selectedFriend == null || s.date == null || s.eventType == null)
      return;

    final now = DateTime.now();
    final rec = EventRecord(
      id: const Uuid().v4(),
      friendId: s.selectedFriend!.id,
      eventId: '',
      eventType: s.eventType,
      amount: s.amount,
      date: s.date!,
      isSent: s.isSend,
      method: s.method,
      attendance: s.attendance,
      memo: s.memo,
      createdBy: userId,
      createdAt: now,
      updatedAt: now,
    );
    try {
      await _repo.add(rec);
    } catch (e) {
      debugPrint('🚨 빠른기록 저장 실패: $e');
      rethrow;
    }
  }

  /// ● 상태 초기화
  void reset() => state = QuickRecordState.initial();
}

/// 🔹 Provider
final quickRecordViewModelProvider =
    NotifierProvider<QuickRecordViewModel, QuickRecordState>(
        QuickRecordViewModel.new);
