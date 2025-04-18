// 📁 lib/repositories/friend_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';

class FriendRepository {
  final _collection = FirebaseFirestore.instance.collection('friends');

  /// 🔹 해당 유저의 친구 목록
  Future<List<Friend>> getFriendsByOwner(String userId) async {
    final snapshot =
        await _collection.where('ownerId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => Friend.fromMap(doc.data())).toList();
  }

  Future<void> addFriend(Friend friend) async {
    await _collection.doc(friend.id).set(friend.toMap());
  }

  Future<void> updateFriend(Friend friend) async {
    await _collection.doc(friend.id).update(friend.toMap());
  }
}
