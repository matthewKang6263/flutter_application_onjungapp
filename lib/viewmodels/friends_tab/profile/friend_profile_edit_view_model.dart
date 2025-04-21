import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/repositories/friend_repository.dart';

/// 🧩 친구 편집 상태 클래스
class FriendProfileEditState {
  final String name;
  final String phone;
  final String? memo;
  final RelationType? relation;

  const FriendProfileEditState({
    this.name = '',
    this.phone = '',
    this.memo,
    this.relation,
  });

  FriendProfileEditState copyWith({
    String? name,
    String? phone,
    String? memo,
    RelationType? relation,
  }) {
    return FriendProfileEditState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      memo: memo ?? this.memo,
      relation: relation ?? this.relation,
    );
  }

  factory FriendProfileEditState.fromFriend(Friend friend) {
    return FriendProfileEditState(
      name: friend.name,
      phone: friend.phone ?? '',
      memo: friend.memo,
      relation: friend.relation,
    );
  }
}

/// 🧠 친구 편집 ViewModel (리팩토링 버전)
class FriendProfileEditViewModel extends Notifier<FriendProfileEditState> {
  final FriendRepository _friendRepo = FriendRepository();

  @override
  FriendProfileEditState build() {
    return const FriendProfileEditState();
  }

  /// 🔸 기존 친구 정보 불러오기
  void load(Friend friend) {
    state = FriendProfileEditState.fromFriend(friend);
  }

  /// 🔸 이름 변경
  void setName(String value) {
    state = state.copyWith(name: value);
  }

  /// 🔸 전화번호 변경
  void setPhone(String value) {
    state = state.copyWith(phone: value);
  }

  /// 🔸 메모 변경
  void setMemo(String value) {
    state = state.copyWith(memo: value);
  }

  /// 🔸 관계 변경
  void setRelation(RelationType? type) {
    state = state.copyWith(relation: type);
  }

  /// 🔸 친구 정보 저장 (수정 전용)
  Future<void> save(String ownerId, String friendId) async {
    final updated = Friend(
      id: friendId,
      ownerId: ownerId,
      name: state.name.trim(),
      phone: state.phone.trim(),
      memo: state.memo,
      relation: state.relation,
      createdAt: DateTime.now(), // createdAt은 Firestore에서 덮어쓰기 방지됨
    );
    await _friendRepo.update(updated);
  }

  /// 🔸 초기화
  void reset() {
    state = const FriendProfileEditState();
  }
}

/// 📦 Provider 등록
final friendProfileEditViewModelProvider =
    NotifierProvider<FriendProfileEditViewModel, FriendProfileEditState>(
  FriendProfileEditViewModel.new,
);
