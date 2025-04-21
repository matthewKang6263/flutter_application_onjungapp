import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/viewmodels/calendar_tab/calendar_tab_view_model.dart';

/// 📌 캘린더 셀에 표시할 태그 우선순위 (Figma 기준)
const List<String> calendarTagPriority = [
  '결혼식',
  '돌잔치',
  '장례식',
  '생일',
  '명절',
  '기타',
];

/// 🔹 [CalendarRecordItem] 리스트에서 중복 라벨 제거 후 우선순위대로 최대 3개 반환
List<String> extractEventTags(List<CalendarRecordItem> records) {
  final unique =
      records.map((e) => e.record.eventType?.label).whereType<String>().toSet();
  final sorted = calendarTagPriority.where(unique.contains).toList();
  if (sorted.length <= 3) return sorted;
  return [...sorted.take(2), '+${sorted.length - 2}'];
}
