// lib/models/enums/method_type.dart

/// 🔹 수단 유형 (현금, 이체, 선물)
enum MethodType {
  cash,
  transfer,
  gift,
}

/// 🔸 MethodType 확장: UI 표시용 한글 라벨
extension MethodTypeLabel on MethodType {
  String get label {
    switch (this) {
      case MethodType.cash:
        return '현금';
      case MethodType.transfer:
        return '이체';
      case MethodType.gift:
        return '선물';
    }
  }

  /// 🔹 문자열 → MethodType 변환 (예외 발생 시 cash로 기본 처리)
  static MethodType fromString(String? value) {
    switch (value) {
      case 'transfer':
        return MethodType.transfer;
      case 'gift':
        return MethodType.gift;
      case 'cash':
      default:
        return MethodType.cash;
    }
  }
}

extension MethodTypeParser on MethodType {
  /// 한글 레이블 → enum
  static MethodType fromLabel(String label) {
    switch (label) {
      case '이체':
        return MethodType.transfer;
      case '선물':
        return MethodType.gift;
      case '현금':
      default:
        return MethodType.cash;
    }
  }
}
