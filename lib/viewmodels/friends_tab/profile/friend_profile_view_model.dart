// 📁 lib/viewmodels/friends_tab/friend_profile_view_model.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/repositories/friend_repository.dart';

/// 👤 친구 프로필 상태
class FriendProfileState {
  final Friend? friend;
  final bool isLoading;

  const FriendProfileState({
    this.friend,
    this.isLoading = false,
  });

  FriendProfileState copyWith({
    Friend? friend,
    bool? isLoading,
  }) {
    return FriendProfileState(
      friend: friend ?? this.friend,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// 🧠 친구 프로필 ViewModel
class FriendProfileViewModel extends Notifier<FriendProfileState> {
  final FriendRepository _friendRepo = FriendRepository();

  @override
  FriendProfileState build() {
    return const FriendProfileState();
  }

  /// 🔹 친구 정보 불러오기
  Future<void> load(String friendId) async {
    state = state.copyWith(isLoading: true);

    try {
      final friend = await _friendRepo.getById(friendId);
      state = state.copyWith(friend: friend, isLoading: false);
    } catch (e) {
      print('❌ 친구 정보 로딩 실패: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  /// 🔸 친구 삭제
  Future<void> delete() async {
    final target = state.friend;
    if (target == null) return;

    try {
      await _friendRepo.delete(target.id);
    } catch (e) {
      print('❌ 친구 삭제 실패: $e');
      rethrow;
    }
  }

  /// 🔸 상태 초기화
  void reset() {
    state = const FriendProfileState();
  }
}

/// 📦 Provider 등록
final friendProfileViewModelProvider =
    NotifierProvider<FriendProfileViewModel, FriendProfileState>(
  FriendProfileViewModel.new,
);
