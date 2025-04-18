import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/repositories/friend_repository.dart';

class FriendListViewModel extends ChangeNotifier {
  final FriendRepository _repository = FriendRepository();

  List<Friend> _friends = [];
  bool _isLoading = false;

  List<Friend> get friends => _friends;
  bool get isLoading => _isLoading;

  /// 🔹 친구 목록 불러오기
  Future<void> loadFriends(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _friends = await _repository.getFriendsByOwner(userId);
    } catch (e) {
      print('🔥 FriendListViewModel.loadFriends 오류: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// 🔹 친구 정보 수정
  Future<void> updateFriend(Friend updated) async {
    try {
      await _repository.updateFriend(updated);
      final index = _friends.indexWhere((f) => f.id == updated.id);
      if (index != -1) {
        _friends[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      print('🔥 FriendListViewModel.updateFriend 오류: $e');
    }
  }
}
