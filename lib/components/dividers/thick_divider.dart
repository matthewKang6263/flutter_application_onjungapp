// lib/components/dividers/thick_divider.dart

import 'package:flutter/material.dart';

/// 🔹 굵은 배경색 줄 (높이: 8, 색: #F9F4EE)
class ThickDivider extends StatelessWidget {
  const ThickDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 8, width: double.infinity, color: const Color(0xFFF9F4EE));
  }
}
