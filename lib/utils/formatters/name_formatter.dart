import 'package:flutter/services.dart';

/// 🔹 이름 입력 포맷터
/// - 최대 20자, 한글/영문/숫자만 허용
class NameInputFormatter extends TextInputFormatter {
  final int maxLength;
  NameInputFormatter({this.maxLength = 20});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length > maxLength) return oldValue;
    final valid = RegExp(r'^[가-힣A-Za-z0-9]*\$').hasMatch(newValue.text);
    return valid ? newValue : oldValue;
  }
}
