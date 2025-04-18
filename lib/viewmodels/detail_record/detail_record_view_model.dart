import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 📦 상세 내역 뷰모델 (읽기/편집 모드 전환 및 입력값 관리)
class DetailRecordViewModel extends ChangeNotifier {
  // 📌 모드 상태 (true: 편집, false: 읽기)
  bool isEditMode = false;

  // 📌 상단 이름 / 관계 정보
  late String name;
  late String relation;

  // 📌 금액 필드
  late TextEditingController amountController;
  late FocusNode amountFocus;

  // 📌 메모 필드
  late TextEditingController memoController;
  late FocusNode memoFocus;

  // 📌 날짜 필드
  late TextEditingController dateController;
  DateTime? selectedDate;

  // 📌 선택형 항목들
  String direction = ''; // 보냄 / 받음
  String eventType = ''; // 결혼식, 돌잔치, 생일 등
  String method = ''; // 현금 / 이체 / 선물
  String attendance = ''; // 참석 / 미참석

  // 📌 날짜 선택 후 unfocus 처리를 위한 context 저장용
  BuildContext? _context;

  /// ✅ getter: 금액 숫자값
  String get amount => amountController.text.trim();

  /// ✅ getter: 메모 내용
  String get memo => memoController.text.trim();

  /// ✅ getter: 날짜 텍스트 (사용자용 포맷)
  String get date => dateController.text.trim();

  /// ✅ getter: 날짜 DateTime
  DateTime? get dateValue => selectedDate;

  /// ✅ dateText로도 접근 가능하도록 호환용 getter
  String get dateText => date;

  /// ✅ ViewModel 초기화 (DetailRecordPage 진입 시 사용)
  void initializeFrom({
    required String name,
    required String relation,
    required String amount,
    required String direction,
    required String eventType,
    required String date,
    required String method,
    required String attendance,
    required String memo,
  }) {
    this.name = name;
    this.relation = relation;
    this.direction = direction;
    this.eventType = eventType;
    this.method = method;
    this.attendance = attendance;

    amountController = TextEditingController(text: amount);
    amountFocus = FocusNode();

    memoController = TextEditingController(text: memo);
    memoFocus = FocusNode();

    dateController = TextEditingController(text: date);
    selectedDate = _parseDate(date);
  }

  /// ✅ 편집 모드 전환
  void setEditMode(bool value) {
    isEditMode = value;
    notifyListeners();
  }

  /// ✅ 직접 notify 호출할 때
  void notify() => notifyListeners();

  /// ✅ 금액 빠른 추가 버튼 처리 (천 단위 쉼표 포함)
  void addAmount(int value) {
    final raw = amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final current = int.tryParse(raw) ?? 0;
    final updated = current + value;
    amountController.text = NumberFormat('#,###').format(updated);
    notifyListeners();
  }

  /// ✅ 날짜 설정
  void setDate(DateTime date) {
    selectedDate = date;
    dateController.text = _formatDate(date);
    notifyListeners();
  }

  /// ✅ 날짜 초기화
  void clearDate() {
    selectedDate = null;
    dateController.clear();
    notifyListeners();
  }

  /// ✅ 선택형 필드 변경 메서드
  void setDirection(String value) {
    direction = value;
    notifyListeners();
  }

  void setEventType(String value) {
    eventType = value;
    notifyListeners();
  }

  void setMethod(String value) {
    method = value;
    notifyListeners();
  }

  void setAttendance(String value) {
    attendance = value;
    notifyListeners();
  }

  /// ✅ 외부에서 context 저장 (날짜 선택 후 unfocus용)
  void setContext(BuildContext context) {
    _context = context;
  }

  /// ✅ 모든 포커스를 해제하는 메서드
  void unfocusAllFields() {
    if (_context != null) {
      FocusScope.of(_context!).unfocus();
    }
  }

  /// ✅ 날짜 포맷 (yyyy년 M월 d일 (E))
  String _formatDate(DateTime date) {
    return DateFormat('yyyy년 M월 d일 (E)', 'ko').format(date);
  }

  /// ✅ 문자열 날짜 -> DateTime 파싱
  DateTime? _parseDate(String dateStr) {
    try {
      return DateFormat('yyyy년 M월 d일 (E)', 'ko').parse(dateStr);
    } catch (_) {
      return null;
    }
  }

  /// ✅ 저장 처리 (향후 DB 반영 시 여기에 연결)
  void save() {
    setEditMode(false); // 저장 후 읽기 모드로 전환
    // TODO: 저장 처리 로직 추가
  }

  /// ✅ 리소스 해제
  @override
  void dispose() {
    amountController.dispose();
    amountFocus.dispose();
    memoController.dispose();
    memoFocus.dispose();
    dateController.dispose();
    super.dispose();
  }
}
