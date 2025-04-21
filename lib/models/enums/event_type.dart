// lib/models/enums/event_type.dart

/// 🔹 경조사 종류 (결혼식, 돌잔치, 장례식, 생일, 명절, 기타)
enum EventType {
  wedding,
  firstBirthday,
  funeral,
  birthday,
  holiday,
  etc,
}

/// 🔸 EventType 확장: UI 표시용 한글 라벨
extension EventTypeLabel on EventType {
  String get label {
    switch (this) {
      case EventType.wedding:
        return '결혼식';
      case EventType.firstBirthday:
        return '돌잔치';
      case EventType.funeral:
        return '장례식';
      case EventType.birthday:
        return '생일';
      case EventType.holiday:
        return '명절';
      case EventType.etc:
        return '기타';
    }
  }

  /// 🔹 문자열 → EventType 변환 (디폴트 etc)
  static EventType fromString(String? value) {
    switch (value) {
      case 'wedding':
        return EventType.wedding;
      case 'firstBirthday':
        return EventType.firstBirthday;
      case 'funeral':
        return EventType.funeral;
      case 'birthday':
        return EventType.birthday;
      case 'holiday':
        return EventType.holiday;
      case 'etc':
      default:
        return EventType.etc;
    }
  }
}

/// 📌 캘린더 필터용 상수 리스트
class EventTypeFilters {
  static const String all = '전체';
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
