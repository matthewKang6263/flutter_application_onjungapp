import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// 🔹 금액 입력 포맷터
/// - 숫자만 허용, 천단위 콤마, 0~9,999,999,999 범위
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.isEmpty) return newValue;
    final value = int.tryParse(text);
    if (value == null || value > 9999999999) return oldValue;
    final formatted = NumberFormat('#,###').format(value);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
