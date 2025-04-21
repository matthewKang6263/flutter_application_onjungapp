// lib/components/bar/step_progress_bar.dart

import 'package:flutter/material.dart';

/// 🔹 3단계 프로그레스 바
/// - currentStep까지 activeColor, 나머지는 inactiveColor
class StepProgressBar extends StatelessWidget {
  final int currentStep; // 1~3 사이 값

  const StepProgressBar({
    super.key,
    required this.currentStep,
  }) : assert(
          currentStep >= 1 && currentStep <= 3,
          'currentStep은 1~3 사이여야 합니다.',
        );

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Color(0xFFC9885C);
    const Color inactiveColor = Color(0xFFF9F4EE);

    return SizedBox(
      height: 4,
      child: Row(
        children: List.generate(3, (index) {
          final bool isActive = index < currentStep;
          return Expanded(
            child: Container(
              color: isActive ? activeColor : inactiveColor,
            ),
          );
        }),
      ),
    );
  }
}
