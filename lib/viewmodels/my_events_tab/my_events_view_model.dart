import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/my_event_model.dart';
import 'package:flutter_application_onjungapp/repositories/my_event_repository.dart';

class MyEventsViewModel extends ChangeNotifier {
  final MyEventRepository _repository = MyEventRepository();

  List<MyEvent> _myEvents = [];
  bool _isLoading = false;

  List<MyEvent> get myEvents => _myEvents;
  bool get isLoading => _isLoading;
  bool get hasEvents => _myEvents.isNotEmpty;

  /// 🔹 경조사 목록 불러오기 (Firestore 연동)
  Future<void> loadMyEvents(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _myEvents = await _repository.getMyEventsForUser(userId);
    } catch (e) {
      print('🔥 MyEventsViewModel.loadMyEvents 오류: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// 🔹 경조사 추가
  Future<void> addEvent(MyEvent event) async {
    await _repository.addMyEvent(event);
    _myEvents.add(event);
    notifyListeners();
  }

  /// 🔹 경조사 삭제
  Future<void> deleteEvent(String id) async {
    await _repository.deleteMyEvent(id);
    _myEvents.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
