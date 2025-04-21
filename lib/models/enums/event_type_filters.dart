import 'package:flutter_application_onjungapp/models/enums/event_type.dart';

/// 📌 캘린더 필터용 경조사 이름 상수 리스트
class EventTypeFilters {
  /// 기본 선택 값 (전체)
  static const String all = '전체';

  /// 실제 필터에서 보여줄 항목 리스트 (Figma 기준)
  static const List<String> allOptions = [
    all,
    '결혼식',
    '돌잔치',
    '장례식',
    '생일',
    '명절',
    '기타',
  ];
}

extension EventTypeParser on EventType {
  static EventType fromLabel(String label) {
    switch (label) {
      case '결혼식':
        return EventType.wedding;
      case '돌잔치':
        return EventType.firstBirthday;
      case '장례식':
        return EventType.funeral;
      case '생일':
        return EventType.birthday;
      case '명절':
        return EventType.holiday;
      case '기타':
        return EventType.etc;
      default:
        throw Exception('Unknown label: $label');
    }
  }
}
