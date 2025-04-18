// 📁 lib/viewmodels/my_events_tab/my_event_add_view_model.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/models/my_event_model.dart';
import 'package:flutter_application_onjungapp/models/event_record_model.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/repositories/friend_repository.dart';
import 'package:flutter_application_onjungapp/repositories/my_event_repository.dart';
import 'package:flutter_application_onjungapp/repositories/event_record_repository.dart';
import 'package:uuid/uuid.dart';

class MyEventAddViewModel extends ChangeNotifier {
  // 🔹 Step 1 상태
  final TextEditingController titleController = TextEditingController();
  final FocusNode titleFocus = FocusNode();

  EventType? selectedEventType;
  DateTime? selectedDate;

  bool get isStep1Complete =>
      titleController.text.trim().isNotEmpty &&
      selectedEventType != null &&
      selectedDate != null;

  void setEventType(EventType? type) {
    selectedEventType = type;
    notifyListeners();
  }

  void clearEventType() {
    selectedEventType = null;
    notifyListeners();
  }

  void setDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void clearDate() {
    selectedDate = null;
    notifyListeners();
  }

  void disposeControllers() {
    titleController.dispose();
    titleFocus.dispose();
    for (var controller in flowerControllers) {
      controller.dispose();
    }
  }

  // 🔹 Step 2 상태
  final FriendRepository _friendRepo = FriendRepository();

  List<Friend> friends = [];
  bool isFriendLoading = false;
  Set<String> selectedFriendIds = {};

  Future<void> loadFriendsForUser(String userId) async {
    isFriendLoading = true;
    notifyListeners();

    try {
      friends = await _friendRepo.getFriendsByOwner(userId);
    } catch (e) {
      print('🚨 친구 로딩 오류: $e');
    }

    isFriendLoading = false;
    notifyListeners();
  }

  void toggleFriendSelection(String id) {
    if (selectedFriendIds.contains(id)) {
      selectedFriendIds.remove(id);
    } else {
      selectedFriendIds.add(id);
    }
    notifyListeners();
  }

  void toggleSelectAllFriends() {
    if (selectedFriendIds.length == friends.length) {
      selectedFriendIds.clear();
    } else {
      selectedFriendIds = friends.map((f) => f.id).toSet();
    }
    notifyListeners();
  }

  void setSelectedFriendIds(Set<String> ids) {
    selectedFriendIds = ids;
    notifyListeners();
  }

  // 🔹 Step 3: 화환 친구 이름 리스트
  List<String> flowerFriendNames = [''];
  List<TextEditingController> flowerControllers = [];

  void initFlowerControllers() {
    flowerControllers = flowerFriendNames
        .map((name) => TextEditingController(text: name))
        .toList();
  }

  void addFlowerFriend() {
    flowerFriendNames.add('');
    flowerControllers.add(TextEditingController());
    notifyListeners();
  }

  void removeFlowerFriend(int index) {
    flowerFriendNames.removeAt(index);
    flowerControllers[index].dispose();
    flowerControllers.removeAt(index);
    notifyListeners();
  }

  void updateFlowerName(int index, String name) {
    flowerFriendNames[index] = name;
    notifyListeners();
  }

  void clearFlowerName(int index) {
    flowerControllers[index].clear();
    flowerFriendNames[index] = '';
    notifyListeners();
  }

  // 🔹 저장 로직
  final MyEventRepository _eventRepo = MyEventRepository();
  final EventRecordRepository _recordRepo = EventRecordRepository();

  Future<MyEvent?> submit(String userId) async {
    if (!isStep1Complete) return null;

    final now = DateTime.now();
    final id = const Uuid().v4();

    final event = MyEvent(
      id: id,
      title: titleController.text.trim(),
      eventType: selectedEventType!,
      date: selectedDate!,
      createdBy: userId,
      createdAt: now,
      updatedAt: now,
      recordIds: selectedFriendIds.toList(),
      flowerFriendNames: flowerControllers
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty)
          .toList(),
    );

    try {
      await _eventRepo.addMyEvent(event);
      return event;
    } catch (e) {
      print('🚨 MyEvent 저장 실패: $e');
      return null;
    }
  }

  Future<MyEvent?> submitAll(String userId) async {
    if (!isStep1Complete) return null;

    final now = DateTime.now();
    final eventId = const Uuid().v4();

    final event = MyEvent(
      id: eventId,
      title: titleController.text.trim(),
      eventType: selectedEventType!,
      date: selectedDate!,
      createdBy: userId,
      createdAt: now,
      updatedAt: now,
      recordIds: selectedFriendIds.toList(),
      flowerFriendNames: flowerControllers
          .map((c) => c.text.trim())
          .where((t) => t.isNotEmpty)
          .toList(),
    );

    try {
      await _eventRepo.addMyEvent(event);

      for (final friendId in selectedFriendIds) {
        final record = EventRecord(
          id: const Uuid().v4(),
          friendId: friendId,
          eventId: eventId,
          eventType: event.eventType, // ✅ 여기에 추가!
          amount: 0,
          date: event.date,
          isSent: false,
          method: null,
          attendance: null,
          memo: '',
          createdBy: userId,
          createdAt: now,
          updatedAt: now,
        );
        await _recordRepo.addEventRecord(record);
      }

      return event;
    } catch (e) {
      print('🚨 전체 저장 실패: $e');
      return null;
    }
  }
}
