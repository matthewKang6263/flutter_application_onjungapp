import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/event_record_model.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/repositories/event_record_repository.dart';
import 'package:flutter_application_onjungapp/repositories/friend_repository.dart';

class CalendarRecordItem {
  final EventRecord record;
  final Friend friend;

  CalendarRecordItem({
    required this.record,
    required this.friend,
  });
}

class CalendarExchangeSummary {
  final int sentCount;
  final int sentAmount;
  final int receivedCount;
  final int receivedAmount;

  CalendarExchangeSummary({
    required this.sentCount,
    required this.sentAmount,
    required this.receivedCount,
    required this.receivedAmount,
  });
}

class CalendarTabViewModel extends ChangeNotifier {
  final EventRecordRepository _recordRepo = EventRecordRepository();
  final FriendRepository _friendRepo = FriendRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<CalendarRecordItem> _allItems = [];
  List<CalendarRecordItem> get allItems => _allItems;

  DateTime? _currentMonth;
  String? _userId;

  Future<void> loadRecords(String userId, DateTime targetMonth) async {
    _isLoading = true;
    _userId = userId;
    _currentMonth = targetMonth;
    notifyListeners();

    try {
      final friends = await _friendRepo.getFriendsByOwner(userId);
      final records =
          await _recordRepo.getEventRecordsForMonth(userId, targetMonth);

      _allItems = records.map((record) {
        final friend = friends.firstWhere((f) => f.id == record.friendId);
        return CalendarRecordItem(record: record, friend: friend);
      }).toList();
    } catch (e) {
      print('🚨 CalendarTabViewModel load error: $e');
      _allItems = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  List<CalendarRecordItem> getRecordsForDate(DateTime date) {
    return _allItems.where((item) {
      final d = item.record.date;
      return d.year == date.year && d.month == date.month && d.day == date.day;
    }).toList();
  }

  List<CalendarRecordItem> getRecordsForMonth() {
    return _allItems;
  }

  CalendarExchangeSummary getSummaryForMonth() {
    final sent = _allItems.where((r) => r.record.isSent);
    final received = _allItems.where((r) => !r.record.isSent);

    return CalendarExchangeSummary(
      sentCount: sent.length,
      sentAmount: sent.fold(0, (sum, r) => sum + r.record.amount),
      receivedCount: received.length,
      receivedAmount: received.fold(0, (sum, r) => sum + r.record.amount),
    );
  }
}
