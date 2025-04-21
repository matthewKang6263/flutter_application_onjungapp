// lib/components/dialogs/custom_snack_bar.dart

import 'package:flutter/material.dart';

/// 🔹 온정 스타일 커스텀 스낵바
/// - floating, 배경색 #2A2928, 모서리 둥글게
void showOnjungSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFF2A2928),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      content: Text(message,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Pretendard')),
      duration: const Duration(seconds: 2),
    ),
  );
}
