import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/repositories/friend_repository.dart';
import 'package:uuid/uuid.dart';

class FriendAddEditViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController memoController = TextEditingController();
  RelationType selectedRelation = RelationType.friend;

  bool get isValid => nameController.text.trim().isNotEmpty;

  void setRelation(RelationType relation) {
    selectedRelation = relation;
    notifyListeners();
  }

  void clear() {
    nameController.clear();
    phoneController.clear();
    memoController.clear();
    selectedRelation = RelationType.friend;
  }

  Future<void> save(String userId) async {
    final now = DateTime.now();
    final newFriend = Friend(
      id: const Uuid().v4(),
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      relation: selectedRelation,
      memo: memoController.text.trim(),
      ownerId: userId,
      createdAt: now,
    );
    await FriendRepository().addFriend(newFriend);
  }

  void disposeControllers() {
    nameController.dispose();
    phoneController.dispose();
    memoController.dispose();
  }
}
