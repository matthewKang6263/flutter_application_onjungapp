// 📁 lib/viewmodels/friends_tab/friend_list_view_model.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/repositories/friend_repository.dart';

/// 👥 친구 리스트 상태
class FriendListState {
  final List<Friend> friends;
  final bool isLoading;
  final bool hasLoaded; // ✅ 중복 로딩 방지용 플래그

  const FriendListState({
    this.friends = const [],
    this.isLoading = false,
    this.hasLoaded = false,
  });

  FriendListState copyWith({
    List<Friend>? friends,
    bool? isLoading,
    bool? hasLoaded,
  }) {
    return FriendListState(
      friends: friends ?? this.friends,
      isLoading: isLoading ?? this.isLoading,
      hasLoaded: hasLoaded ?? this.hasLoaded,
    );
  }
}

/// 🧠 친구 탭 메인 ViewModel (Riverpod Notifier)
class FriendListViewModel extends Notifier<FriendListState> {
  final FriendRepository _friendRepo = FriendRepository();

  @override
  FriendListState build() {
    return const FriendListState();
  }

  /// 🔸 친구 목록 불러오기
  Future<void> load(String ownerId) async {
    // 이미 로딩 완료된 경우 중복 호출 방지
    if (state.hasLoaded) return;

    state = state.copyWith(isLoading: true);
    try {
      final loadedFriends = await _friendRepo.getAll(ownerId);
      state = state.copyWith(
        friends: loadedFriends,
        isLoading: false,
        hasLoaded: true,
      );
    } catch (e) {
      print('❌ 친구 목록 로드 실패: \$e');
      state = state.copyWith(isLoading: false);
    }
  }

  /// 🔸 친구 목록 초기화
  void reset() {
    state = const FriendListState();
  }
}

/// 📦 Provider 등록
final friendListViewModelProvider =
    NotifierProvider<FriendListViewModel, FriendListState>(
  FriendListViewModel.new,
);
