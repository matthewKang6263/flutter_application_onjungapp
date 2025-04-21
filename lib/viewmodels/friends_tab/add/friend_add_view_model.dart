// 📁 lib/viewmodels/friends_tab/add/friend_add_view_model.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/repositories/friend_repository.dart';

/// 👤 친구 추가용 ViewModel 상태
class FriendAddState {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController memoController;
  final RelationType? selectedRelation;

  FriendAddState({
    required this.nameController,
    required this.phoneController,
    required this.memoController,
    this.selectedRelation,
  });

  FriendAddState copyWith({
    TextEditingController? nameController,
    TextEditingController? phoneController,
    TextEditingController? memoController,
    RelationType? selectedRelation,
  }) {
    return FriendAddState(
      nameController: nameController ?? this.nameController,
      phoneController: phoneController ?? this.phoneController,
      memoController: memoController ?? this.memoController,
      selectedRelation: selectedRelation ?? this.selectedRelation,
    );
  }
}

/// 🧠 친구 추가 ViewModel (Riverpod Notifier)
class FriendAddViewModel extends Notifier<FriendAddState> {
  final FriendRepository _friendRepo = FriendRepository();

  @override
  FriendAddState build() {
    return FriendAddState(
      nameController: TextEditingController(),
      phoneController: TextEditingController(),
      memoController: TextEditingController(),
    );
  }

  /// 🔹 이름/번호/메모 필드 유효성 검사
  bool get isValid =>
      state.nameController.text.trim().isNotEmpty &&
      state.phoneController.text.trim().isNotEmpty &&
      state.selectedRelation != null;

  /// 🔸 관계 설정
  void setRelation(RelationType type) {
    state = state.copyWith(selectedRelation: type);
  }

  /// 🔸 친구 저장
  Future<void> save(String ownerId) async {
    final newFriend = Friend(
      id: const Uuid().v4(),
      ownerId: ownerId,
      name: state.nameController.text.trim(),
      phone: state.phoneController.text.trim(),
      memo: state.memoController.text.trim(),
      relation: state.selectedRelation,
      createdAt: DateTime.now(),
    );
    await _friendRepo.add(newFriend);
  }

  /// 🔸 입력 초기화
  void clear() {
    state.nameController.clear();
    state.phoneController.clear();
    state.memoController.clear();
    state = state.copyWith(selectedRelation: null);
  }

  /// 🔸 컨트롤러 해제
  void disposeControllers() {
    state.nameController.dispose();
    state.phoneController.dispose();
    state.memoController.dispose();
  }
}

/// 📦 Provider 등록
final friendAddViewModelProvider =
    NotifierProvider<FriendAddViewModel, FriendAddState>(
  FriendAddViewModel.new,
);
