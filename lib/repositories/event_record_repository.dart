// lib/repositories/event_record_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/event_record_model.dart';

/// 🔹 경조사 상세내역 CRUD 처리용 Repository
class EventRecordRepository {
  final _col = FirebaseFirestore.instance.collection('event_records');

  /// 📝 특정 이벤트ID에 해당하는 상세내역 리스트 반환
  Future<List<EventRecord>> getByEvent(String eventId) async {
    try {
      final snap = await _col.where('eventId', isEqualTo: eventId).get();
      return snap.docs.map((d) => EventRecord.fromMap(d.data())).toList();
    } on FirebaseException catch (e) {
      debugPrint('getByEvent 에러: $e');
      rethrow;
    }
  }

  /// 📝 단일 상세내역 조회
  Future<EventRecord?> getById(String recordId) async {
    try {
      final doc = await _col.doc(recordId).get();
      if (!doc.exists) return null;
      return EventRecord.fromMap(doc.data()!);
    } on FirebaseException catch (e) {
      debugPrint('getById EventRecord 에러: $e');
      rethrow;
    }
  }

  /// 🔹 사용자의 모든 상세내역 조회
  Future<List<EventRecord>> getByUser(String userId) async {
    try {
      final snap = await _col.where('createdBy', isEqualTo: userId).get();
      return snap.docs.map((d) => EventRecord.fromMap(d.data())).toList();
    } on FirebaseException catch (e) {
      debugPrint('getByUser 에러: $e');
      rethrow;
    }
  }

  /// 📝 특정 친구ID에 해당하는 상세내역 리스트 반환
  Future<List<EventRecord>> getByFriend(String friendId) async {
    try {
      final snap = await _col.where('friendId', isEqualTo: friendId).get();
      return snap.docs.map((d) => EventRecord.fromMap(d.data())).toList();
    } on FirebaseException catch (e) {
      debugPrint('getByFriend 에러: $e');
      rethrow;
    }
  }

  /// 📝 월별(Year,Month)로 필터링한 상세내역 리스트 반환
  Future<List<EventRecord>> getByMonth(
      String userId, DateTime targetMonth) async {
    final start =
        Timestamp.fromDate(DateTime(targetMonth.year, targetMonth.month, 1));
    final end = Timestamp.fromDate(
        DateTime(targetMonth.year, targetMonth.month + 1, 1));

    try {
      final snap = await _col
          .where('createdBy', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: start)
          .where('date', isLessThan: end)
          .get();
      return snap.docs.map((d) => EventRecord.fromMap(d.data())).toList();
    } on FirebaseException catch (e) {
      debugPrint('getByMonth 에러: $e');
      rethrow;
    }
  }

  /// 🆕 상세내역 추가
  Future<void> add(EventRecord record) async {
    try {
      await _col.doc(record.id).set(record.toMap());
    } on FirebaseException catch (e) {
      debugPrint('add EventRecord 에러: $e');
      rethrow;
    }
  }

  /// 🔄 상세내역 수정
  Future<void> update(EventRecord record) async {
    try {
      await _col.doc(record.id).update(record.toMap());
    } on FirebaseException catch (e) {
      debugPrint('update EventRecord 에러: $e');
      rethrow;
    }
  }

  /// ❌ 단일 상세내역 삭제
  Future<void> delete(String recordId) async {
    try {
      await _col.doc(recordId).delete();
    } on FirebaseException catch (e) {
      debugPrint('delete EventRecord 에러: $e');
      rethrow;
    }
  }

  /// ❌ 이벤트ID 기준으로 일괄 삭제 (Batch Write 적용)
  Future<void> deleteByEvent(String eventId) async {
    try {
      final snap = await _col.where('eventId', isEqualTo: eventId).get();
      final batch = FirebaseFirestore.instance.batch();
      for (var doc in snap.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      debugPrint('deleteByEvent 에러: $e');
      rethrow;
    }
  }
}
