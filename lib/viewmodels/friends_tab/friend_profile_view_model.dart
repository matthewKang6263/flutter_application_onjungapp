import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/repositories/friend_repository.dart';

class FriendProfileViewModel extends ChangeNotifier {
  final FriendRepository _repository = FriendRepository();

  Friend? _friend;
  bool _isEditMode = false;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController memoController;
  String relationLabel = '';

  bool get isEditMode => _isEditMode;
  Friend? get friend => _friend;

  /// 🔹 데이터 초기화
  void load(Friend friend) {
    _friend = friend;
    nameController = TextEditingController(text: friend.name);
    phoneController = TextEditingController(text: friend.phone ?? '');
    memoController = TextEditingController(text: friend.memo ?? '');
    relationLabel = friend.relation?.label ?? '';
  }

  /// 🔹 편집 모드 전환
  void toggleEditMode() {
    _isEditMode = !_isEditMode;
    notifyListeners();
  }

  void updateRelationLabel(String label) {
    relationLabel = label;
    notifyListeners();
  }

  /// 🔹 저장 처리
  Future<void> save() async {
    if (_friend == null) return;

    final updated = _friend!.copyWith(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      memo: memoController.text.trim(),
      relation: RelationType.values.firstWhere((r) => r.label == relationLabel,
          orElse: () => RelationType.etc),
    );

    try {
      await _repository.updateFriend(updated);
      _friend = updated;
      _isEditMode = false;
      notifyListeners();
    } catch (e) {
      print('🔥 FriendProfileViewModel.save 오류: $e');
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    memoController.dispose();
    super.dispose();
  }
}
