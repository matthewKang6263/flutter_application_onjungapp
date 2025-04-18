// 📁 lib/viewmodels/search/search_friend_view_model.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/repositories/friend_repository.dart';

class SearchFriendViewModel extends ChangeNotifier {
  final FriendRepository _friendRepo = FriendRepository();

  List<Friend> _friends = [];
  List<Friend> get friends => _friends;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchFriends(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _friends = await _friendRepo.getFriendsByOwner(userId);
    } catch (e) {
      print('🚨 친구 불러오기 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
