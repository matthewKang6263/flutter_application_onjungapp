// 📁 lib/viewmodels/search/search_friend_view_model.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/repositories/friend_repository.dart';

/// 🔹 친구 검색 상태
class SearchFriendState {
  final List<Friend> friends;
  final bool isLoading;
  const SearchFriendState({required this.friends, required this.isLoading});
  factory SearchFriendState.initial() =>
      const SearchFriendState(friends: [], isLoading: false);
  SearchFriendState copyWith({List<Friend>? friends, bool? isLoading}) =>
      SearchFriendState(
          friends: friends ?? this.friends,
          isLoading: isLoading ?? this.isLoading);
}

/// 🔹 친구 검색 뷰모델
class SearchFriendViewModel extends Notifier<SearchFriendState> {
  final _repo = FriendRepository();
  @override
  SearchFriendState build() => SearchFriendState.initial();

  /// ● 사용자 친구 불러오기
  Future<void> fetchFriends(String userId) async {
    state = state.copyWith(isLoading: true);
    try {
      final list = await _repo.getAll(userId);
      state = state.copyWith(friends: list, isLoading: false);
    } catch (e) {
      debugPrint('🚨 친구 로드 실패: $e');
      state = state.copyWith(isLoading: false);
    }
  }
}

/// 🔹 Provider
final searchFriendViewModelProvider =
    NotifierProvider<SearchFriendViewModel, SearchFriendState>(
        SearchFriendViewModel.new);
