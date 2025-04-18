// 📁 lib/viewmodels/quick_record/quick_record_view_model.dart

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_application_onjungapp/models/enums/attendance_type.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/models/enums/method_type.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/models/event_record_model.dart';
import 'package:flutter_application_onjungapp/repositories/event_record_repository.dart';

class QuickRecordViewModel extends ChangeNotifier {
  final EventRecordRepository _recordRepo = EventRecordRepository();

  // 🔹 Step 1
  bool isSend = true;
  Friend? selectedFriend;
  int amount = 0;
  MethodType? selectedMethod;

  // 🔹 Step 2
  EventType? selectedEventType;
  DateTime? selectedDate;

  // 🔹 Step 3
  AttendanceType? attendance;
  String memo = '';

  // ✅ 입력 메서드들

  void toggleIsSend(bool value) {
    isSend = value;
    notifyListeners();
  }

  void selectFriend(Friend friend) {
    selectedFriend = friend;
    notifyListeners();
  }

  void clearFriend() {
    selectedFriend = null;
    notifyListeners();
  }

  void setAmount(int value) {
    amount = value;
    notifyListeners();
  }

  void addAmount(int value) {
    amount += value;
    notifyListeners();
  }

  void selectMethod(MethodType? method) {
    selectedMethod = method;
    notifyListeners();
  }

  void selectEventType(EventType? eventType) {
    selectedEventType = eventType;
    notifyListeners();
  }

  void selectDate(DateTime? date) {
    selectedDate = date;
    notifyListeners();
  }

  void selectAttendance(AttendanceType? value) {
    attendance = value;
    notifyListeners();
  }

  void updateMemo(String value) {
    memo = value;
    notifyListeners();
  }

  void clearMemo() {
    memo = '';
    notifyListeners();
  }

  // ✅ 제출 메서드
  Future<void> submit(String userId) async {
    if (selectedFriend == null ||
        selectedDate == null ||
        selectedEventType == null) return;

    final now = DateTime.now();
    final record = EventRecord(
      id: const Uuid().v4(),
      friendId: selectedFriend!.id,
      eventId: '', // 빠른기록은 eventId 없음
      eventType: selectedEventType,
      amount: amount,
      date: selectedDate!,
      isSent: isSend,
      method: selectedMethod,
      attendance: attendance,
      memo: memo,
      createdBy: userId,
      createdAt: now,
      updatedAt: now,
    );

    try {
      await _recordRepo.addEventRecord(record);
    } catch (e) {
      print('🚨 빠른기록 저장 실패: $e');
      rethrow;
    }
  }

  void reset() {
    isSend = true;
    selectedFriend = null;
    amount = 0;
    selectedMethod = null;
    selectedEventType = null;
    selectedDate = null;
    attendance = null;
    memo = '';
    notifyListeners();
  }
}
