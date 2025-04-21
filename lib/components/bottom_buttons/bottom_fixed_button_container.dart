// lib/components/bottom_buttons/bottom_fixed_button_container.dart

import 'package:flutter/material.dart';

/// 🔹 하단 고정 버튼 컨테이너
/// - SafeArea + 좌우 16, 하단 24 padding 포함
class BottomFixedButtonContainer extends StatelessWidget {
  final Widget child;

  const BottomFixedButtonContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: child,
    );
  }
}
