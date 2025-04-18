// 📁 lib/utils/phone_utils.dart

/// 🔹 전화번호를 '000-0000-0000' 형식으로 정규화합니다.
/// - 국가번호(+82)는 제거하고 0으로 시작하게 처리
/// - 지역번호(예: 서울 02)는 3자리로 보정 (예: 002)
/// - 유효하지 않은 번호는 '번호 없음' 반환
String normalizePhoneNumber(String raw) {
  // 모든 숫자만 추출
  String digits = raw.replaceAll(RegExp(r'\D'), '');

  // 국가번호(+82 등) 제거
  if (digits.startsWith('82')) {
    digits = '0${digits.substring(2)}';
  }

  // 길이가 9~11자 이내가 아니면 잘못된 번호로 간주
  if (digits.length < 9 || digits.length > 11) {
    return '번호 없음';
  }

  // 서울 (02) 번호 보정: '02' → '002'
  if (digits.length == 9 && digits.startsWith('2')) {
    digits = '0$digits'; // 예: 02 → 002
  }

  // 9자리 (지역번호 + 7자리): 002-123-4567 형태
  if (digits.length == 10 && digits.startsWith('00')) {
    final area = digits.substring(0, 3);
    final part1 = digits.substring(3, 6);
    final part2 = digits.substring(6);
    return '$area-$part1-$part2';
  }

  // 10자리: 000-0000-0000 형태
  if (digits.length == 10) {
    final area = digits.substring(0, 3);
    final part1 = digits.substring(3, 6);
    final part2 = digits.substring(6);
    return '$area-$part1-$part2';
  }

  // 11자리: 000-0000-0000 형태
  if (digits.length == 11) {
    final area = digits.substring(0, 3);
    final part1 = digits.substring(3, 7);
    final part2 = digits.substring(7);
    return '$area-$part1-$part2';
  }

  return '번호 없음';
}

/// 🔹 여러 전화번호 중에서 가장 적절한 번호를 선택합니다.
/// - 우선순위: 010 > 011~019 > 지역번호 > 나머지 무시
/// - normalizePhoneNumber() 기준으로 '번호 없음' 아닌 것 중 하나만 반환
String? chooseBestPhoneNumber(List<String> numbers) {
  for (final raw in numbers) {
    final normalized = normalizePhoneNumber(raw);
    if (normalized.startsWith('010')) return normalized;
  }
  for (final raw in numbers) {
    final normalized = normalizePhoneNumber(raw);
    if (RegExp(r'^01[1|6|7|8|9]').hasMatch(normalized)) return normalized;
  }
  for (final raw in numbers) {
    final normalized = normalizePhoneNumber(raw);
    if (!normalized.contains('번호 없음')) return normalized;
  }
  return null; // 전부 유효하지 않은 경우
}
