// 📁 lib/utils/validators.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 🔹 이름 유효성 검사
/// - 빈 값 불가
/// - 한글/영문/숫자 허용
/// - 특수문자/띄어쓰기/줄바꿈 불가
bool isValidName(String input) {
  if (input.trim().isEmpty) return false;

  // ✅ 입력값은 오직 한글, 영문, 숫자만 허용 (띄어쓰기, 특수문자 불가)
  final regex = RegExp(r'^[가-힣a-zA-Z0-9]+$');
  return regex.hasMatch(input);
}

/// 🔹 전화번호 유효성 검사
/// - 000-0000-0000 형식만 허용
bool isValidPhone(String input) {
  // ✅ 정확히 3-4-4 자리 숫자만 허용
  final regex = RegExp(r'^\d{3}-\d{4}-\d{4}$');
  return regex.hasMatch(input);
}

/// 🔹 금액 유효성 검사
/// - 숫자만 추출 후 1 ~ 9999999999 사이일 때 유효
bool isValidAmount(String input) {
  final digitsOnly = input.replaceAll(RegExp(r'[^0-9]'), ''); // 숫자만 추출
  final number = int.tryParse(digitsOnly) ?? 0;
  return number > 0 && number <= 9999999999;
}

/// 🔹 메모 유효성 검사
/// - 최대 글자 수 제한 (기본 200)
/// - 최대 줄 수 제한 (기본 10)
bool isValidMemo(String input, {int maxLength = 200, int maxLines = 10}) {
  final lineCount = '\n'.allMatches(input).length + 1; // 줄 수 계산
  return input.characters.length <= maxLength && lineCount <= maxLines;
}

/// 🔹 검색창 유효성 검사
/// - 공백만 있는 경우는 무효
bool isValidSearch(String input) {
  return input.trim().isNotEmpty;
}

/// 🔹 전화번호 포맷 함수
/// - 01012345678 → 010-1234-5678 형식으로 변환
String formatPhoneNumber(String raw) {
  final digits = raw.replaceAll(RegExp(r'[^0-9]'), ''); // 숫자만 추출
  if (digits.length == 11) {
    return '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7)}';
  } else if (digits.length == 10) {
    return '${digits.substring(0, 3)}-${digits.substring(3, 6)}-${digits.substring(6)}';
  }
  return raw; // 그 외 형식은 원본 반환
}

/// 🔹 숫자 포맷 (쉼표 추가)
String formatNumberWithComma(int number) =>
    NumberFormat('#,###').format(number);

/// 🔹 날짜 포맷 (예: 2025년 4월 10일 (목))
String formatDateToKorean(DateTime date) {
  const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  final day = weekdays[date.weekday % 7];
  return '${date.year}년 ${date.month}월 ${date.day}일 ($day)';
}

/// 🔹 에러 메시지 상수 정의
const String nameErrorMessage = '이름은 한글, 영문, 숫자만 입력해 주세요';
const String phoneErrorMessage = '올바른 전화번호 형식이 아니에요';
const String amountErrorMessage = '금액은 1원 이상 10억 이하로 입력해 주세요';
const String memoErrorMessage = '메모는 10줄 이내, 200자 이하로 입력해 주세요';
const String searchErrorMessage = '검색어를 입력해 주세요';
