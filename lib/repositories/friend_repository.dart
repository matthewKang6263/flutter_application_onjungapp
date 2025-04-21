// lib/repositories/friend_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/friend_model.dart';

/// 🔹 친구 CRUD 처리용 Repository
class FriendRepository {
  final _col = FirebaseFirestore.instance.collection('friends');

  /// 📝 사용자의 친구 전체 목록 조회
  Future<List<Friend>> getAll(String ownerId) async {
    try {
      final snap = await _col.where('ownerId', isEqualTo: ownerId).get();
      return snap.docs.map((d) => Friend.fromMap(d.data())).toList();
    } on FirebaseException catch (e) {
      debugPrint('getAll Friends 에러: $e');
      rethrow;
    }
  }

  /// 🆕 친구 추가
  Future<void> add(Friend friend) async {
    try {
      await _col.doc(friend.id).set(friend.toMap());
    } on FirebaseException catch (e) {
      debugPrint('add Friend 에러: $e');
      rethrow;
    }
  }

  /// 🔄 친구 정보 수정
  Future<void> update(Friend friend) async {
    try {
      await _col.doc(friend.id).update(friend.toMap());
    } on FirebaseException catch (e) {
      debugPrint('update Friend 에러: $e');
      rethrow;
    }
  }

  /// ❌ 친구 삭제
  Future<void> delete(String friendId) async {
    try {
      await _col.doc(friendId).delete();
    } on FirebaseException catch (e) {
      debugPrint('delete Friend 에러: $e');
      rethrow;
    }
  }

  /// 📝 단일 친구 조회 (없으면 예외)
  Future<Friend> getById(String friendId) async {
    try {
      final doc = await _col.doc(friendId).get();
      if (!doc.exists) {
        throw Exception('해당 친구 정보가 없습니다.');
      }
      return Friend.fromMap(doc.data()!);
    } on FirebaseException catch (e) {
      debugPrint('getById Friend 에러: $e');
      rethrow;
    }
  }
}
