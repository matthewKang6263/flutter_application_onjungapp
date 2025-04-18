import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile_model.dart';

class UserRepository {
  final _collection = FirebaseFirestore.instance.collection('users');

  /// 🔹 사용자 프로필 가져오기
  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _collection.doc(uid).get();
    if (!doc.exists) return null;
    return UserProfile.fromMap(doc.data()!);
  }

  /// 🔹 사용자 프로필 업데이트
  Future<void> updateUserProfile(UserProfile profile) async {
    await _collection.doc(profile.uid).set(profile.toMap());
  }
}
