// 📁 lib/components/dialogs/custom_snack_bar.dart

import 'package:flutter/material.dart';

/// ✅ 온정 스타일의 커스텀 스낵바
/// - 텍스트만 전달받아 스타일 통일
/// - 전체 앱에서 재사용 가능
void showOnjungSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color(0xFF2A2928),
      elevation: 0,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Pretendard',
        ),
      ),
      duration: const Duration(seconds: 2),
    ),
  );
}
