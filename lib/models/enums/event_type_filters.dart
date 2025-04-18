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
