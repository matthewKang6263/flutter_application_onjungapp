// lib/utils/number_formats.dart

import 'package:intl/intl.dart';

/// 🔹 정수에 천 단위 콤마를 추가한 문자열 반환
String formatNumberWithComma(int number) {
  return NumberFormat('#,###').format(number);
}
