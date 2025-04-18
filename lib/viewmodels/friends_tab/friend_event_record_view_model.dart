import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/event_record_model.dart';
import 'package:flutter_application_onjungapp/repositories/event_record_repository.dart';
import 'package:flutter_application_onjungapp/repositories/friend_repository.dart';

class FriendEventRecordViewModel extends ChangeNotifier {
  final EventRecordRepository _recordRepo = EventRecordRepository();

  List<EventRecord> _records = [];
  bool _isLoading = false;

  List<EventRecord> get records => _records;
  bool get isLoading => _isLoading;

  /// 🔹 특정 친구의 모든 상세내역 불러오기
  Future<void> loadRecordsForFriend(String friendId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _records = await _recordRepo.getEventRecordsForFriend(friendId);
    } catch (e) {
      print('🔥 FriendEventRecordViewModel.loadRecordsForFriend 오류: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// 🔹 전체 친구의 모든 상세내역 불러오기
  Future<void> loadRecordsForAll(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final friendRepo = FriendRepository();
      final friends = await friendRepo.getFriendsByOwner(userId);

      _records = [];
      for (final friend in friends) {
        final records = await _recordRepo.getEventRecordsForFriend(friend.id);
        _records.addAll(records);
      }
    } catch (e) {
      print('🔥 FriendEventRecordViewModel.loadRecordsForAll 오류: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// 🔹 내역 수정 (기존 내역이 View에 바인딩되어 있을 경우)
  Future<void> updateRecord(EventRecord updated) async {
    try {
      await _recordRepo.updateEventRecord(updated);
      final index = _records.indexWhere((r) => r.id == updated.id);
      if (index != -1) {
        _records[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      print('🔥 FriendEventRecordViewModel.updateRecord 오류: $e');
    }
  }

  /// 🔹 통계: 총 보낸 금액 / 받은 금액 / 건수 등 계산
  int get totalSentAmount => _records
      .where((r) => r.isSent)
      .fold(0, (sum, r) => sum + (r.amount ?? 0));

  int get totalReceivedAmount => _records
      .where((r) => !r.isSent)
      .fold(0, (sum, r) => sum + (r.amount ?? 0));

  int get sentCount => _records.where((r) => r.isSent).length;
  int get receivedCount => _records.where((r) => !r.isSent).length;
}
