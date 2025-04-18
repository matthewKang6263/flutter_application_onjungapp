// 📁 lib/components/bottom_buttons/bottom_fixed_button_container.dart

import 'package:flutter/material.dart';

/// ✅ 하단 고정 버튼 컨테이너
/// - SafeArea + 하단 여백(24px) + 좌우 패딩(16px)을 포함하여
///   항상 바닥에 고정되는 하단 버튼 영역을 구성할 때 사용합니다.
/// - 버튼이 하나 또는 두 개일 경우 모두 대응 가능하며,
///   버튼 위젯은 외부에서 전달받습니다.
class BottomFixedButtonContainer extends StatelessWidget {
  final Widget child; // 버튼 1개 또는 2개를 감싸는 Row/Column 등

  const BottomFixedButtonContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 24), // 좌우 패딩 + 하단 여백
      child: child,
    );
  }
}
