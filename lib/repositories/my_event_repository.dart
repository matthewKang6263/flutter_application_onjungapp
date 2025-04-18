import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/my_event_model.dart';

class MyEventRepository {
  final _collection = FirebaseFirestore.instance.collection('my_events');

  /// 🔹 해당 유저의 경조사 리스트 가져오기
  Future<List<MyEvent>> getMyEventsForUser(String userId) async {
    final snapshot = await _collection.where('userId', isEqualTo: userId).get();
    return snapshot.docs.map((doc) => MyEvent.fromMap(doc.data())).toList();
  }

  /// 🔹 경조사 추가
  Future<void> addMyEvent(MyEvent event) async {
    await _collection.doc(event.id).set(event.toMap());
  }

  /// 🔹 경조사 삭제
  Future<void> deleteMyEvent(String eventId) async {
    await _collection.doc(eventId).delete();
  }

  /// 🔹 경조사 정보 수정
  Future<void> updateMyEvent(MyEvent event) async {
    await _collection.doc(event.id).update({
      'title': event.title,
      'eventType': event.eventType.name,
      'date': event.date.toIso8601String(),
      'updatedAt': event.updatedAt.toIso8601String(),
    });
  }
}
