// 📁 lib/viewmodels/my_events_tab/my_event_detail_view_model.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_application_onjungapp/models/my_event_model.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/models/event_record_model.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/repositories/friend_repository.dart';
import 'package:flutter_application_onjungapp/repositories/event_record_repository.dart';
import 'package:flutter_application_onjungapp/repositories/my_event_repository.dart';

/// 🔹 경조사 상세 상태 모델
class MyEventDetailState {
  final MyEvent? event; // 현재 보여질 경조사 데이터
  final List<Friend> friends; // 초대(참여) 대상 친구 목록
  final List<EventRecord> records; // 해당 경조사의 장부 내역
  final bool isLoading; // 데이터 로딩 중 여부

  const MyEventDetailState({
    this.event,
    this.friends = const [],
    this.records = const [],
    this.isLoading = false,
  });

  /// 🔹 불변성을 위한 복사 메서드
  MyEventDetailState copyWith({
    MyEvent? event,
    List<Friend>? friends,
    List<EventRecord>? records,
    bool? isLoading,
  }) {
    return MyEventDetailState(
      event: event ?? this.event,
      friends: friends ?? this.friends,
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// ▶︎ 초깃값 생성
  factory MyEventDetailState.initial() => const MyEventDetailState();
}

/// 🔹 경조사 상세 뷰모델
/// - FamilyNotifier를 사용해 파라미터로 MyEvent 전달
class MyEventDetailViewModel
    extends FamilyNotifier<MyEventDetailState, MyEvent> {
  final _friendRepo = FriendRepository();
  final _recordRepo = EventRecordRepository();
  final _eventRepo = MyEventRepository();

  List<TextEditingController> flowerControllers = [];
  List<EventRecord> attendanceRecords = [];

  @override
  MyEventDetailState build(MyEvent event) {
    // 초기 상태 설정 후 데이터 로딩
    _loadAllData(event);
    return MyEventDetailState.initial().copyWith(event: event);
  }

  /// 🔸 친구 목록 + 장부 내역 가져오기
  Future<void> _loadAllData(MyEvent event) async {
    state = state.copyWith(isLoading: true);
    try {
      final friends = await _friendRepo.getAll(event.createdBy);
      final records = await _recordRepo.getByEvent(event.id);
      state = state.copyWith(
        friends: friends,
        records: records,
        isLoading: false,
      );
    } catch (e) {
      debugPrint('🔥 상세 데이터 로딩 실패: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  // ───────────────────────────────
  // 🔹 요약 정보 수정 메서드
  // ───────────────────────────────

  /// ▪︎ 제목 수정
  void updateTitle(String title) {
    final ev = state.event?.copyWith(title: title, updatedAt: DateTime.now());
    state = state.copyWith(event: ev);
  }

  /// ▪︎ 날짜 수정
  void updateDate(DateTime date) {
    final ev = state.event?.copyWith(date: date, updatedAt: DateTime.now());
    state = state.copyWith(event: ev);
  }

  /// ▪︎ 경조사 타입 수정
  void updateEventType(EventType type) {
    final ev =
        state.event?.copyWith(eventType: type, updatedAt: DateTime.now());
    state = state.copyWith(event: ev);
  }

  /// ▪︎ 화환 리스트 수정 (리스트로 교체)
  void updateFlowerNames(List<String> names) {
    final ev = state.event?.copyWith(
      flowerFriendNames: names,
      updatedAt: DateTime.now(),
    );
    state = state.copyWith(event: ev);
  }

  /// 🔹 요약 정보 저장 요청
  Future<bool> saveSummary() async {
    final ev = state.event;
    if (ev == null) return false;
    try {
      await _eventRepo.update(ev);
      return true;
    } catch (e) {
      debugPrint('🚨 요약 저장 실패: $e');
      return false;
    }
  }

  // ───────────────────────────────
  // 🔹 장부(내역) 수정
  // ───────────────────────────────

  /// ▪︎ 선택된 기록만 남기고 나머지 삭제
  Future<void> saveLedgerChanges(Set<String> keepIds) async {
    final existing = state.records.map((r) => r.id).toSet();
    final toDelete = existing.difference(keepIds);
    try {
      for (final id in toDelete) {
        await _recordRepo.delete(id);
      }
      // 삭제 후 재로딩
      return _loadAllData(state.event!);
    } catch (e) {
      debugPrint('🚨 장부 수정 실패: $e');
    }
  }

  // ───────────────────────────────
  // 🌸 화환 입력 관리
  // ───────────────────────────────

  /// ▪︎ 컨트롤러 초기화
  void initFlowerControllers() {
    flowerControllers = (state.event?.flowerFriendNames ?? [])
        .map((n) => TextEditingController(text: n))
        .toList();
    if (flowerControllers.isEmpty) {
      flowerControllers.add(TextEditingController());
    }
  }

  /// ▪︎ 새 화환 추가
  void addFlowerController() {
    flowerControllers.add(TextEditingController());
  }

  /// ▪︎ 화환 컨트롤러 제거
  void removeFlowerController(int idx) {
    flowerControllers[idx].dispose();
    flowerControllers.removeAt(idx);
  }

  /// ▪︎ 텍스트 변경 반영
  void changeFlowerName(int idx, String v) {
    flowerControllers[idx].text = v;
  }

  /// ▪︎ 화환 저장
  Future<bool> saveFlowers() async {
    final names = flowerControllers
        .map((c) => c.text.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    updateFlowerNames(names);
    return saveSummary();
  }

  // ───────────────────────────────
  // 👥 새로운 장부 인원 추가
  // ───────────────────────────────

  /// ▪︎ eventId에 새로운 기록 추가 후 재로딩
  Future<void> addRecordsForGuests(Set<String> friendIds) async {
    final ev = state.event;
    if (ev == null) return;
    final now = DateTime.now();
    final newRecs = friendIds.map((fid) => EventRecord(
          id: const Uuid().v4(),
          friendId: fid,
          eventId: ev.id,
          eventType: ev.eventType,
          amount: 0,
          date: ev.date,
          isSent: false,
          method: null,
          attendance: null,
          memo: '',
          createdBy: ev.createdBy,
          createdAt: now,
          updatedAt: now,
        ));
    try {
      for (final r in newRecs) {
        await _recordRepo.add(r);
      }
      await _loadAllData(ev);
    } catch (e) {
      debugPrint('🚨 인원 추가 실패: $e');
    }
  }
}

/// 🔹 FamilyProvider 등록
final myEventDetailViewModelProvider = NotifierProvider.family<
    MyEventDetailViewModel, MyEventDetailState, MyEvent>(
  MyEventDetailViewModel.new,
);
