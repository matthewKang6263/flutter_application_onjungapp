import 'package:flutter/material.dart';

/// 1~3단계용 프로그레스 바
/// - 전체 너비를 3등분하여 각 단계를 채움
/// - 현재 단계까지는 활성 색상, 나머지는 비활성 색상
class StepProgressBar extends StatelessWidget {
  final int currentStep; // 현재 단계 (1~3만 허용)

  const StepProgressBar({
    super.key,
    required this.currentStep,
  }) : assert(
            currentStep >= 1 && currentStep <= 3, 'currentStep은 1~3 사이여야 합니다.');

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Color(0xFFC9885C); // 진행된 단계 색상
    const Color inactiveColor = Color(0xFFF9F4EE); // 배경(미진행) 색상

    return SizedBox(
      height: 4,
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index < currentStep;
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
