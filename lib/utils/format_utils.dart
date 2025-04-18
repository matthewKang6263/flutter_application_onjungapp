import 'package:intl/intl.dart';

/// 🔹 천 단위 쉼표 (ex. 123456 → 123,456)
String formatNumberWithComma(int number) =>
    NumberFormat('#,###').format(number);

/// 🔹 원 단위 붙이기 (ex. 123456 → 123,456원)
String formatCurrency(int amount) => '${formatNumberWithComma(amount)}원';

/// 🔹 간단한 날짜 포맷 (ex. 2025.04.16)
String formatSimpleDate(DateTime date) {
  return DateFormat('yyyy.MM.dd').format(date);
}

/// 🔹 "25년 4월 13일 (일)" 형태
String formatShortFullDate(DateTime date) {
  return DateFormat('yy년 M월 d일 (E)', 'ko_KR').format(date);
}

/// 🔹 "2025년 4월 13일 (일)" 형태
String formatFullDate(DateTime date) {
  return DateFormat('yyyy년 M월 d일 (E)', 'ko_KR').format(date);
}
