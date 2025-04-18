/// 🔹 경조사 종류 (결혼식, 돌잔치, 장례식, 생일, 명절, 기타)
enum EventType {
  wedding,
  firstBirthday,
  funeral,
  birthday,
  holiday,
  etc,
}

/// 🔸 한글 라벨 반환용 확장 (UI에 노출할 문자열)
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
}
