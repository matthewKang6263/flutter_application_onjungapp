// lib/repositories/my_event_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/my_event_model.dart';

/// 🔹 나의 경조사 이벤트 CRUD 처리용 Repository
class MyEventRepository {
  final _col = FirebaseFirestore.instance.collection('my_events');

  /// 📝 사용자의 모든 이벤트 조회
  Future<List<MyEvent>> getAll(String userId) async {
    try {
      final snap = await _col.where('createdBy', isEqualTo: userId).get();
      return snap.docs.map((d) => MyEvent.fromMap(d.data())).toList();
    } on FirebaseException catch (e) {
      debugPrint('getAll MyEvent 에러: $e');
      rethrow;
    }
  }

  /// 🆕 이벤트 추가 (단일 배치 쓰기 예시)
  Future<void> add(MyEvent event) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      final docRef = _col.doc(event.id);
      batch.set(docRef, event.toMap());
      // ▶️ 관련 EventRecord 생성이 필요하면 여기에 batch.set 추가
      await batch.commit();
    } on FirebaseException catch (e) {
      debugPrint('add MyEvent 에러: $e');
      rethrow;
    }
  }

  /// 🔄 이벤트 수정 (제목·종류·날짜·updatedAt만 갱신)
  Future<void> update(MyEvent event) async {
    try {
      await _col.doc(event.id).update({
        'title': event.title,
        'eventType': event.eventType.name,
        'date': event.date.toIso8601String(),
        'updatedAt': event.updatedAt.toIso8601String(),
      });
    } on FirebaseException catch (e) {
      debugPrint('update MyEvent 에러: $e');
      rethrow;
    }
  }

  /// ❌ 이벤트 삭제
  Future<void> delete(String eventId) async {
    try {
      await _col.doc(eventId).delete();
    } on FirebaseException catch (e) {
      debugPrint('delete MyEvent 에러: $e');
      rethrow;
    }
  }
}
