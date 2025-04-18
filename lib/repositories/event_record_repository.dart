import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_record_model.dart';

class EventRecordRepository {
  final _collection = FirebaseFirestore.instance.collection('event_records');

  /// 🔹 특정 경조사의 상세 내역 가져오기
  Future<List<EventRecord>> getEventRecordsForEvent(String eventId) async {
    final snapshot =
        await _collection.where('eventId', isEqualTo: eventId).get();
    return snapshot.docs.map((doc) => EventRecord.fromMap(doc.data())).toList();
  }

  /// 🔹 특정 친구의 모든 내역 가져오기
  Future<List<EventRecord>> getEventRecordsForFriend(String friendId) async {
    final snapshot =
        await _collection.where('friendId', isEqualTo: friendId).get();
    return snapshot.docs.map((doc) => EventRecord.fromMap(doc.data())).toList();
  }

  /// 🔹 해당 월의 전체 기록 조회 (캘린더 탭용)
  Future<List<EventRecord>> getEventRecordsForMonth(
      String userId, DateTime targetMonth) async {
    final snapshot =
        await _collection.where('createdBy', isEqualTo: userId).get();

    return snapshot.docs
        .map((doc) => EventRecord.fromMap(doc.data()))
        .where((record) =>
            record.date.year == targetMonth.year &&
            record.date.month == targetMonth.month)
        .toList();
  }

  /// 🔹 상세 내역 추가
  Future<void> addEventRecord(EventRecord record) async {
    await _collection.doc(record.id).set(record.toMap());
  }

  /// 🔹 상세 내역 수정
  Future<void> updateEventRecord(EventRecord record) async {
    await _collection.doc(record.id).update(record.toMap());
  }

  /// 🔹 상세 내역 삭제
  Future<void> deleteEventRecord(String recordId) async {
    await _collection.doc(recordId).delete();
  }

  /// 🔹 특정 경조사(eventId)에 해당하는 모든 상세내역 삭제
  Future<void> deleteByEventId(String eventId) async {
    try {
      final snapshot =
          await _collection.where('eventId', isEqualTo: eventId).get();
      final batch = FirebaseFirestore.instance.batch();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      print('🚨 deleteByEventId error: $e');
      rethrow;
    }
  }
}
