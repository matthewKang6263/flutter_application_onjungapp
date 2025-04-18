import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/event_record_model.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/models/my_event_model.dart';
import 'package:flutter_application_onjungapp/repositories/event_record_repository.dart';
import 'package:flutter_application_onjungapp/repositories/friend_repository.dart';
import 'package:flutter_application_onjungapp/repositories/my_event_repository.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';

class MyEventDetailViewModel extends ChangeNotifier {
  final FriendRepository _friendRepo = FriendRepository();
  final EventRecordRepository _recordRepo = EventRecordRepository();
  final MyEventRepository _eventRepo = MyEventRepository();

  List<Friend> friends = [];
  List<EventRecord> records = [];
  MyEvent? _currentEvent;

  bool isLoading = false;

  List<TextEditingController> flowerControllers = [];

  MyEvent get currentEvent => _currentEvent!;

  // 🔹 전체 데이터 로딩
  Future<void> loadData(MyEvent event) async {
    isLoading = true;
    notifyListeners();

    try {
      _currentEvent = event;
      friends = await _friendRepo.getFriendsByOwner(event.createdBy);
      records = await _recordRepo.getEventRecordsForEvent(event.id);
    } catch (e) {
      print('🔥 오류 발생: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // 🔹 요약 수정용 업데이트 메서드
  void updateTitle(String title) {
    _currentEvent = _currentEvent!.copyWith(title: title);
    notifyListeners();
  }

  void updateDate(DateTime date) {
    _currentEvent = _currentEvent!.copyWith(date: date);
    notifyListeners();
  }

  void updateEventType(EventType eventType) {
    _currentEvent = _currentEvent!.copyWith(eventType: eventType);
    notifyListeners();
  }

  void updateFlowerFriendNames(List<String> updated) {
    _currentEvent = _currentEvent!.copyWith(
      flowerFriendNames: updated,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  // 🔹 요약 저장 처리
  Future<void> submitSummaryEdit() async {
    if (_currentEvent == null) return;
    try {
      await _eventRepo.updateMyEvent(_currentEvent!);
    } catch (e) {
      print('🚨 요약 저장 실패: $e');
    }
  }

  // 🔹 Ledger 편집 저장 처리
  Future<void> saveLedgerChanges(Set<String> selectedIds) async {
    final existingIds = records.map((r) => r.id).toSet();
    final toDelete = existingIds.difference(selectedIds);

    try {
      for (final id in toDelete) {
        await _recordRepo.deleteEventRecord(id);
      }
      records = await _recordRepo.getEventRecordsForEvent(_currentEvent!.id);
      notifyListeners();
    } catch (e) {
      print('🔥 Ledger 저장 중 오류: $e');
    }
  }

  // 🔹 화환 컨트롤러 초기화
  void initFlowerControllers() {
    flowerControllers.clear();
    for (final name in _currentEvent?.flowerFriendNames ?? []) {
      flowerControllers.add(TextEditingController(text: name));
    }
    if (flowerControllers.isEmpty) {
      flowerControllers.add(TextEditingController());
    }
  }

  void addFlowerFriend() {
    flowerControllers.add(TextEditingController());
    notifyListeners();
  }

  void removeFlowerFriend(int index) {
    flowerControllers[index].dispose();
    flowerControllers.removeAt(index);
    notifyListeners();
  }

  void updateFlowerName(int index, String name) {
    flowerControllers[index].text = name;
  }

  void clearFlowerName(int index) {
    flowerControllers[index].clear();
    notifyListeners();
  }

  Future<void> saveFlowerFriends() async {
    final updated = flowerControllers
        .map((c) => c.text.trim())
        .where((name) => name.isNotEmpty)
        .toList();
    updateFlowerFriendNames(updated);
    await submitSummaryEdit();
  }
}
