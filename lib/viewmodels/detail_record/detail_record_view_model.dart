// 📁 lib/viewmodels/detail_record/detail_record_view_model.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type_filters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_onjungapp/models/enums/attendance_type.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/models/enums/method_type.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';
import 'package:flutter_application_onjungapp/models/event_record_model.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/repositories/event_record_repository.dart';
import 'package:flutter_application_onjungapp/repositories/friend_repository.dart';

class DetailRecordViewModel extends ChangeNotifier {
  final String recordId;

  final _eventRepo = EventRecordRepository();
  final _friendRepo = FriendRepository();

  bool isEditMode = false;
  EventRecord? _record;
  Friend? _friend;

  late TextEditingController amountController;
  late TextEditingController memoController;
  late TextEditingController dateController;

  late FocusNode amountFocus;
  late FocusNode memoFocus;
  DateTime? selectedDate;
  BuildContext? _context;

  DetailRecordViewModel(this.recordId) {
    _load();
  }

  EventRecord? get record => _record;

  String get name => _friend?.name ?? '-';
  String get relation => _friend?.relation?.label ?? '-';

  String get direction => _record?.isSent == true ? '보냄' : '받음';
  String get eventType => _record?.eventType?.label ?? '-';
  String get method => _record?.method?.label ?? '-';
  String get attendance => _record?.attendance?.label ?? '-';

  String get amount => amountController.text.trim();
  String get memo => memoController.text.trim();
  String get date => dateController.text.trim();
  DateTime? get dateValue => selectedDate;
  String get dateText => date;

  Future<void> _load() async {
    try {
      final data = await _eventRepo.getById(recordId);
      if (data != null) {
        _record = data;
        _friend = await _friendRepo.getById(data.friendId);

        amountController =
            TextEditingController(text: _formatAmount(data.amount));
        memoController = TextEditingController(text: data.memo ?? '');
        dateController = TextEditingController(text: _formatDate(data.date));
        selectedDate = data.date;
      } else {
        amountController = TextEditingController();
        memoController = TextEditingController();
        dateController = TextEditingController();
      }

      amountFocus = FocusNode();
      memoFocus = FocusNode();
      notifyListeners();
    } catch (e) {
      debugPrint('❌ 상세 내역 로딩 실패: $e');
    }
  }

  void setEditMode(bool value) {
    isEditMode = value;
    notifyListeners();
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  void unfocusAllFields() {
    if (_context != null) FocusScope.of(_context!).unfocus();
  }

  void addAmount(int value) {
    final raw = amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final current = int.tryParse(raw) ?? 0;
    final updated = current + value;
    amountController.text = _formatAmount(updated);
    notifyListeners();
  }

  void setDate(DateTime date) {
    selectedDate = date;
    dateController.text = _formatDate(date);
    notifyListeners();
  }

  void clearDate() {
    selectedDate = null;
    dateController.clear();
    notifyListeners();
  }

  void setDirection(String value) {
    _record = _record?.copyWith(isSent: value == '보냄');
    notifyListeners();
  }

  void setMethod(String value) {
    final method = MethodTypeParser.fromLabel(value);
    _record = _record?.copyWith(method: method);
    notifyListeners();
  }

  void setAttendance(String value) {
    final attendance = AttendanceTypeParser.fromLabel(value);
    _record = _record?.copyWith(attendance: attendance);
    notifyListeners();
  }

  void setEventType(String value) {
    final eventType = EventTypeParser.fromLabel(value);
    _record = _record?.copyWith(eventType: eventType); // ✅ 이름 일치
    notifyListeners();
  }

  void notify() => notifyListeners();

  Future<void> save() async {
    if (_record == null) return;

    final updated = _record!.copyWith(
      amount: int.tryParse(amount.replaceAll(',', '')) ?? 0,
      memo: memo,
      date: selectedDate ?? _record!.date,
      updatedAt: DateTime.now(),
    );
    try {
      await _eventRepo.update(updated);
      _record = updated;
      setEditMode(false);
      debugPrint('✅ 저장 완료: $recordId');
    } catch (e) {
      debugPrint('❌ 저장 실패: $e');
    }
  }

  Future<void> delete() async {
    try {
      await _eventRepo.delete(recordId);
      debugPrint('🗑️ 삭제 완료: $recordId');
    } catch (e) {
      debugPrint('❌ 삭제 실패: $e');
    }
  }

  String _formatAmount(int amount) => NumberFormat('#,###').format(amount);

  String _formatDate(DateTime date) =>
      DateFormat('yyyy년 M월 d일 (E)', 'ko').format(date);

  @override
  void dispose() {
    amountController.dispose();
    memoController.dispose();
    dateController.dispose();
    amountFocus.dispose();
    memoFocus.dispose();
    super.dispose();
  }
}

/// ✅ Riverpod NotifierProvider 선언
final detailRecordViewModelProvider =
    ChangeNotifierProvider.family<DetailRecordViewModel, String>(
        (ref, recordId) {
  return DetailRecordViewModel(recordId);
});
