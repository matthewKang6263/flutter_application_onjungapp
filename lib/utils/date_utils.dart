// 📁 lib/utils/date_utils.dart

import 'package:intl/intl.dart';

/// 🔹 "YYYY.MM.DD" 형태로 포맷팅 (예: 2025.04.09)
/// - 예: formatSimpleDate(DateTime(2025, 4, 9)) → "2025.04.09"
String formatSimpleDate(DateTime date) {
  final y = date.year;
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y.$m.$d';
}

/// 🔹 "YYYY년 M월" 형태로 포맷팅 (예: 2025년 4월)
/// - 캘린더 상단 월 표시 등에서 사용
/// - 예: formatYearMonth(DateTime(2025, 4, 1)) → "2025년 4월"
String formatYearMonth(DateTime date) {
  return DateFormat('yyyy년 M월', 'ko_KR').format(date);
}

/// 🔹 "YY년 M월 D일 (요일)" 포맷 (예: 25년 4월 13일 (일))
/// - 간결한 전체 날짜 표현
/// - 예: formatShortFullDate(DateTime(2025, 4, 13)) → "25년 4월 13일 (일)"
String formatShortFullDate(DateTime date) {
  return DateFormat('yy년 M월 d일 (E)', 'ko_KR').format(date);
}

/// 🔹 "YYYY년 M월 D일 (요일)" 포맷 (예: 2025년 4월 13일 (일))
/// - 상세 뷰나 다이어리 등에서 사용
/// - 예: formatFullDate(DateTime(2025, 4, 13)) → "2025년 4월 13일 (일)"
String formatFullDate(DateTime date) {
  return DateFormat('yyyy년 M월 d일 (E)', 'ko_KR').format(date);
}
