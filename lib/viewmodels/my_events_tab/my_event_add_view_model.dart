// 📁 lib/viewmodels/my_events_tab/my_event_add_view_model.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/event_record_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/models/my_event_model.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/repositories/friend_repository.dart';
import 'package:flutter_application_onjungapp/repositories/my_event_repository.dart';
import 'package:flutter_application_onjungapp/repositories/event_record_repository.dart';

/// 🧠 경조사 추가 단계별 상태
class MyEventAddState {
  final EventType? selectedEventType;
  final DateTime? selectedDate;
  final List<Friend> friends;
  final Set<String> selectedFriendIds;
  final List<String> flowerFriendNames;
  final bool isFriendLoading;

  const MyEventAddState({
    this.selectedEventType,
    this.selectedDate,
    this.friends = const [],
    this.selectedFriendIds = const {},
    this.flowerFriendNames = const [],
    this.isFriendLoading = false,
  });

  MyEventAddState copyWith({
    EventType? selectedEventType,
    DateTime? selectedDate,
    List<Friend>? friends,
    Set<String>? selectedFriendIds,
    List<String>? flowerFriendNames,
    bool? isFriendLoading,
  }) {
    return MyEventAddState(
      selectedEventType: selectedEventType ?? this.selectedEventType,
      selectedDate: selectedDate ?? this.selectedDate,
      friends: friends ?? this.friends,
      selectedFriendIds: selectedFriendIds ?? this.selectedFriendIds,
      flowerFriendNames: flowerFriendNames ?? this.flowerFriendNames,
      isFriendLoading: isFriendLoading ?? this.isFriendLoading,
    );
  }
}

/// 🧠 경조사 추가 뷰모델
class MyEventAddViewModel extends Notifier<MyEventAddState> {
  final titleController = TextEditingController();
  final titleFocus = FocusNode();
  final _friendRepo = FriendRepository();
  final _eventRepo = MyEventRepository();
  final _recordRepo = EventRecordRepository();

  List<TextEditingController> flowerControllers = [];

  @override
  MyEventAddState build() => const MyEventAddState();

  /// ▶︎ Step1 완료 여부: 제목/종류/날짜 모두 선택되었는지
  bool get isStep1Complete =>
      titleController.text.trim().isNotEmpty &&
      state.selectedEventType != null &&
      state.selectedDate != null;

  /// ● 이벤트 종류 선택
  void setEventType(EventType? t) =>
      state = state.copyWith(selectedEventType: t);

  /// 이벤트 종류 초기화
  void clearEventType() => state = state.copyWith(selectedEventType: null);

  /// ● 날짜 선택
  void setDate(DateTime d) => state = state.copyWith(selectedDate: d);

  /// 날짜 초기화
  void clearDate() => state = state.copyWith(selectedDate: null);

  /// ● 친구 목록 로드 (Step2)
  Future<void> loadFriends(String userId) async {
    state = state.copyWith(isFriendLoading: true);
    try {
      final list = await _friendRepo.getAll(userId);
      state = state.copyWith(friends: list, isFriendLoading: false);
    } catch (_) {
      state = state.copyWith(isFriendLoading: false);
    }
  }

  /// ● 친구 선택/해제 토글
  void toggleFriend(String id) {
    final set = {...state.selectedFriendIds};
    set.contains(id) ? set.remove(id) : set.add(id);
    state = state.copyWith(selectedFriendIds: set);
  }

  /// 2단계: 선택된 친구 ID 집합을 한 번에 설정
  void setSelectedFriendIds(Set<String> ids) {
    state = state.copyWith(selectedFriendIds: ids);
  }

  /// 2단계: 전체 선택/전체 해제 토글
  void toggleSelectAll() {
    final allIds = state.friends.map((f) => f.id).toSet();
    final isAllSelected = state.selectedFriendIds.length == allIds.length;
    state = state.copyWith(
      selectedFriendIds: isAllSelected ? <String>{} : allIds,
    );
  }

  /// ● 화환 컨트롤러 초기화 (Step3)
  void initFlowerControllers() {
    flowerControllers = state.flowerFriendNames
        .map((n) => TextEditingController(text: n))
        .toList();
    if (flowerControllers.isEmpty) {
      flowerControllers.add(TextEditingController());
    }
  }

  /// ● 화환 친구 추가/제거
  void addFlowerFriend() {
    flowerControllers.add(TextEditingController());
    state = state.copyWith(flowerFriendNames: [...state.flowerFriendNames, '']);
  }

  void removeFlowerFriend(int i) {
    flowerControllers[i].dispose();
    flowerControllers.removeAt(i);
    final names = [...state.flowerFriendNames]..removeAt(i);
    state = state.copyWith(flowerFriendNames: names);
  }

  void updateFlowerName(int i, String v) {
    final names = [...state.flowerFriendNames];
    names[i] = v;
    state = state.copyWith(flowerFriendNames: names);
  }

  /// 인덱스 i 의 화환 친구 이름만 비우고, 필드는 남겨둡니다.
  void clearFlowerName(int i) {
    // 1) 컨트롤러 텍스트 클리어
    flowerControllers[i].clear();

    // 2) 상태의 리스트에서도 해당 인덱스만 빈 문자열로 바꿔 줍니다.
    final names = [...state.flowerFriendNames];
    if (i < names.length) {
      names[i] = '';
      state = state.copyWith(flowerFriendNames: names);
    }
  }

  /// ● 최종 이벤트 생성 & 저장
  Future<MyEvent?> submit(String userId) async {
    if (!isStep1Complete) return null;
    final now = DateTime.now();
    final id = const Uuid().v4();
    final event = MyEvent(
      id: id,
      title: titleController.text.trim(),
      eventType: state.selectedEventType!,
      date: state.selectedDate!,
      createdBy: userId,
      createdAt: now,
      updatedAt: now,
      recordIds: state.selectedFriendIds.toList(),
      flowerFriendNames: flowerControllers
          .map((c) => c.text.trim())
          .where((s) => s.isNotEmpty)
          .toList(),
    );

    try {
      // 1) MyEvent 저장
      await _eventRepo.add(event);

      // 2) 선택된 친구 수만큼 EventRecord 자동 생성
      for (final friendId in state.selectedFriendIds) {
        final rec = EventRecord(
          id: const Uuid().v4(),
          friendId: friendId,
          eventId: id,
          eventType: state.selectedEventType!,
          amount: 0,
          date: state.selectedDate!,
          isSent: false,
          method: null,
          attendance: null,
          memo: '',
          createdBy: userId,
          createdAt: now,
          updatedAt: now,
        );
        await _recordRepo.add(rec);
      }

      return event;
    } catch (e) {
      debugPrint('🚨 이벤트 생성 실패: $e');
      return null;
    }
  }

  /// ● 리소스 정리
  void disposeControllers() {
    titleController.dispose();
    titleFocus.dispose();
    for (final c in flowerControllers) c.dispose();
  }
}

/// 🔹 Provider 등록
final myEventAddViewModelProvider =
    NotifierProvider<MyEventAddViewModel, MyEventAddState>(
        MyEventAddViewModel.new);
