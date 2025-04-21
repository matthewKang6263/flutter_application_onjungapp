import 'package:flutter/services.dart';

/// 🔹 메모 입력 포맷터
/// - 최대 200자, 최대 10줄
class MemoInputFormatter extends TextInputFormatter {
  final int maxLength;
  final int maxLines;
  MemoInputFormatter({this.maxLength = 200, this.maxLines = 10});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final lines = '\n'.allMatches(newValue.text).length + 1;
    if (newValue.text.length > maxLength || lines > maxLines) {
      return oldValue;
    }
    return newValue;
  }
}
