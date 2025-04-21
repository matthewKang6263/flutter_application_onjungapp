// 📁 lib/viewmodels/friends_tab/friend_event_record_view_model.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/models/event_record_model.dart';
import 'package:flutter_application_onjungapp/repositories/event_record_repository.dart';

/// 📊 친구 교환 내역 상태
class FriendEventRecordState {
  final List<EventRecord> records;
  final int sentCount;
  final int receivedCount;
  final int sentAmount;
  final int receivedAmount;
  final bool isLoading;

  const FriendEventRecordState({
    this.records = const [],
    this.sentCount = 0,
    this.receivedCount = 0,
    this.sentAmount = 0,
    this.receivedAmount = 0,
    this.isLoading = false,
  });

  FriendEventRecordState copyWith({
    List<EventRecord>? records,
    int? sentCount,
    int? receivedCount,
    int? sentAmount,
    int? receivedAmount,
    bool? isLoading,
  }) {
    return FriendEventRecordState(
      records: records ?? this.records,
      sentCount: sentCount ?? this.sentCount,
      receivedCount: receivedCount ?? this.receivedCount,
      sentAmount: sentAmount ?? this.sentAmount,
      receivedAmount: receivedAmount ?? this.receivedAmount,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// 🧠 친구 교환 내역 ViewModel (Riverpod Notifier)
class FriendEventRecordViewModel extends Notifier<FriendEventRecordState> {
  final EventRecordRepository _recordRepo = EventRecordRepository();

  @override
  FriendEventRecordState build() {
    return const FriendEventRecordState();
  }

  /// 🔸 특정 친구 ID에 해당하는 기록 불러오기
  Future<void> load(String ownerId, String friendId) async {
    state = state.copyWith(isLoading: true);

    try {
      final records = await _recordRepo.getByFriend(friendId);
      final sent = records.where((r) => r.isSent).toList();
      final received = records.where((r) => !r.isSent).toList();

      state = state.copyWith(
        records: records,
        sentCount: sent.length,
        receivedCount: received.length,
        sentAmount: sent.fold<int>(0, (sum, r) => sum + r.amount),
        receivedAmount: received.fold<int>(0, (sum, r) => sum + r.amount),
        isLoading: false,
      );
    } catch (e) {
      print('❌ 친구 교환 내역 로드 실패: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  /// ✅ 전체 친구 교환 기록 불러오기 (FriendsPage용)
  Future<void> loadAll(String ownerId) async {
    state = state.copyWith(isLoading: true);
    try {
      final records = await _recordRepo.getByUser(ownerId);
      state = state.copyWith(records: records, isLoading: false);
    } catch (e) {
      print('❌ 전체 기록 로드 실패: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  /// 🔸 상태 초기화
  void reset() {
    state = const FriendEventRecordState();
  }
}

/// 📦 Provider 등록
final friendEventRecordViewModelProvider =
    NotifierProvider<FriendEventRecordViewModel, FriendEventRecordState>(
  FriendEventRecordViewModel.new,
);
