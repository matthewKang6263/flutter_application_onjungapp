/// 🔹 이름 유효성: 빈값 금지, 한글/영문/숫자만
bool isValidName(String input) =>
    input.isNotEmpty && RegExp(r'^[가-힣A-Za-z0-9]+\$').hasMatch(input);

/// 🔹 전화번호 유효성: 000-0000-0000
bool isValidPhone(String input) =>
    RegExp(r'^\d{3}-\d{4}-\d{4}\$').hasMatch(input);

/// 🔹 금액 유효성: 1원~9,999,999,999원
bool isValidAmount(String input) {
  final num = int.tryParse(input.replaceAll(RegExp(r'[^0-9]'), ''));
  return num != null && num > 0 && num <= 9999999999;
}

/// 🔹 메모 유효성: 최대200자, 최대10줄
bool isValidMemo(String input, {int maxLength = 200, int maxLines = 10}) =>
    input.length <= maxLength && '\n'.allMatches(input).length < maxLines;

/// 🔹 검색 유효성: 빈 공백 제외
bool isValidSearch(String input) => input.trim().isNotEmpty;
