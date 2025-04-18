import 'package:flutter_application_onjungapp/models/enums/event_type.dart'; // ✅ label 확장
import 'package:flutter_application_onjungapp/viewmodels/calendar_tab/calendar_tab_viewmodel.dart'; // ✅ CalendarRecordItem 모델

/// 📌 캘린더 셀에서 사용할 경조사 태그 우선순위 (Figma 기준)
/// - eventType.label 기준으로 정렬
const List<String> calendarTagPriority = [
  '결혼식',
  '돌잔치',
  '장례식',
  '생일',
  '명절',
  '기타',
];

/// 🔹 해당 기록들에서 태그만 추출 (우선순위 정렬 + 최대 3개)
///
/// - records: CalendarRecordItem 리스트
/// - 반환: ['결혼식', '돌잔치', '+2'] 형태의 최대 3개 리스트
List<String> extractEventTags(List<CalendarRecordItem> records) {
  // ✅ null 체크 추가
  final uniqueTags = records
      .map((e) => e.record.eventType?.label)
      .where((label) => label != null) // null 제거
      .cast<String>() // Object? → String
      .toSet();

  final sorted =
      calendarTagPriority.where((tag) => uniqueTags.contains(tag)).toList();

  if (sorted.length <= 3) return sorted;
  return [...sorted.sublist(0, 2), '+${sorted.length - 2}'];
}
