// 📁 lib/viewmodels/my_events_tab/my_events_view_model.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/models/my_event_model.dart';
import 'package:flutter_application_onjungapp/repositories/my_event_repository.dart';

/// 🔹 내 경조사 리스트 상태 모델
class MyEventsState {
  final List<MyEvent> events; // 사용자 소유 경조사 목록
  final bool isLoading; // 로딩 중 표시

  const MyEventsState({
    this.events = const [],
    this.isLoading = false,
  });

  MyEventsState copyWith({
    List<MyEvent>? events,
    bool? isLoading,
  }) {
    return MyEventsState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// 🧠 내 경조사 목록 뷰모델
class MyEventsViewModel extends Notifier<MyEventsState> {
  final _repo = MyEventRepository();

  @override
  MyEventsState build() => const MyEventsState();

  /// 🔸 전체 경조사 로드
  Future<void> loadAll(String userId) async {
    state = state.copyWith(isLoading: true);
    try {
      final list = await _repo.getAll(userId);
      state = state.copyWith(events: list, isLoading: false);
    } catch (e) {
      debugPrint('❌ 경조사 불러오기 실패: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  /// 🔸 새 경조사 추가
  Future<void> add(MyEvent ev) async {
    try {
      await _repo.add(ev);
      state = state.copyWith(events: [...state.events, ev]);
    } catch (e) {
      debugPrint('❌ 경조사 추가 실패: $e');
    }
  }

  /// 🔸 경조사 삭제
  Future<void> remove(String eventId) async {
    try {
      await _repo.delete(eventId);
      state = state.copyWith(
        events: state.events.where((e) => e.id != eventId).toList(),
      );
    } catch (e) {
      debugPrint('❌ 경조사 삭제 실패: $e');
    }
  }

  /// 🔹 테스트용 상태 초기화
  void reset() => state = const MyEventsState();
}

/// 🔹 Provider 등록
final myEventsViewModelProvider =
    NotifierProvider<MyEventsViewModel, MyEventsState>(
  MyEventsViewModel.new,
);
