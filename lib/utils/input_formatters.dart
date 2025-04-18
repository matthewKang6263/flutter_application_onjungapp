// 📁 lib/utils/input_formatters.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// 🔹 금액 입력 포맷터
/// - 숫자만 허용
/// - 천 단위 쉼표
/// - 최대 9999999999까지만 입력 허용
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 🔹 아무 입력도 없으면 빈 값 그대로 허용
    if (newValue.text.trim().isEmpty) {
      return newValue;
    }

    // 🔹 숫자만 필터링
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final number = int.tryParse(digitsOnly);

    // 🔹 숫자 변환 실패 or 범위 초과 시 oldValue 유지
    if (number == null || number > 9999999999) {
      return oldValue;
    }

    // 🔸 쉼표까지만 포맷 (원 제거!)
    final formatted = NumberFormat('#,###').format(number);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// 🔹 전화번호 입력 포맷터
/// - '000-0000-0000' 형식 자동 적용
/// - 숫자 외 문자 제거
class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    String formatted = '';
    if (digitsOnly.length <= 3) {
      formatted = digitsOnly;
    } else if (digitsOnly.length <= 7) {
      formatted = '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3)}';
    } else if (digitsOnly.length <= 11) {
      formatted =
          '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3, 7)}-${digitsOnly.substring(7)}';
    } else {
      return oldValue;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// 🔹 메모 입력 포맷터
/// - 최대 200자, 최대 10줄까지 허용
class MemoInputFormatter extends TextInputFormatter {
  final int maxLength;
  final int maxLines;

  MemoInputFormatter({this.maxLength = 200, this.maxLines = 10});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final lineCount = '\n'.allMatches(newValue.text).length + 1;
    if (newValue.text.characters.length > maxLength || lineCount > maxLines) {
      return oldValue;
    }
    return newValue;
  }
}

/// 🔹 이름 입력 제한 포맷터
/// - 기본 20자 제한
class NameInputFormatter extends TextInputFormatter {
  final int maxLength;

  NameInputFormatter({this.maxLength = 20});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.characters.length > maxLength) {
      return oldValue;
    }
    return newValue;
  }
}

/// 🔹 숫자 포맷 (쉼표)
String formatNumberWithComma(int number) =>
    NumberFormat('#,###').format(number);

/// 🔹 날짜 포맷 (2025년 4월 10일 (목))
String formatDateToKorean(DateTime date) {
  const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  final day = weekdays[date.weekday % 7];
  return '${date.year}년 ${date.month}월 ${date.day}일 ($day)';
}
