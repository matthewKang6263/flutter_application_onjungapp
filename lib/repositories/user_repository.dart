// lib/repositories/user_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user_profile_model.dart';

/// 🔹 사용자 프로필 CRUD 처리용 Repository
class UserRepository {
  final _col = FirebaseFirestore.instance.collection('users');

  /// 📝 사용자 프로필 조회
  Future<UserProfile?> getProfile(String uid) async {
    try {
      final doc = await _col.doc(uid).get();
      if (!doc.exists) return null;
      return UserProfile.fromMap(doc.data()!);
    } on FirebaseException catch (e) {
      debugPrint('getProfile 에러: $e');
      rethrow;
    }
  }

  /// 🔄 사용자 프로필 생성/업데이트
  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      await _col.doc(profile.uid).set(profile.toMap());
    } on FirebaseException catch (e) {
      debugPrint('upsertProfile 에러: $e');
      rethrow;
    }
  }

  /// ❌ 사용자 프로필 삭제
  Future<void> deleteUserProfile(String uid) async {
    try {
      await _col.doc(uid).delete();
      debugPrint('✅ deleteUserProfile 성공: $uid');
    } on FirebaseException catch (e) {
      debugPrint('❌ deleteUserProfile 에러: $e');
      rethrow;
    }
  }
}
