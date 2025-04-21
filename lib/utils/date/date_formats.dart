import 'package:intl/intl.dart';

/// 🔹 'YYYY.MM.DD'
String formatSimpleDate(DateTime date) => DateFormat('yyyy.MM.dd').format(date);

/// 🔹 'YYYY년 M월'
String formatYearMonth(DateTime date) =>
    DateFormat('yyyy년 M월', 'ko_KR').format(date);

/// 🔹 'YY년 M월 D일 (요일)'
String formatShortFullDate(DateTime date) =>
    DateFormat('yy년 M월 d일 (E)', 'ko_KR').format(date);

/// 🔹 'YYYY년 M월 D일 (요일)'
String formatFullDate(DateTime date) =>
    DateFormat('yyyy년 M월 d일 (E)', 'ko_KR').format(date);
