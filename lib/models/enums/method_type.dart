/// 🔹 수단 종류 (현금, 이체, 선물)
enum MethodType {
  cash,
  transfer,
  gift,
}

/// 🔸 한글 라벨 반환용 확장
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
}
