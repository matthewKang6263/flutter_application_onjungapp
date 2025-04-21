// lib/components/buttons/add_friend_button.dart

import 'package:flutter/material.dart';

/// 🔹 고정 크기 '친구 추가' 버튼
/// - [label]: 텍스트, [height]/[width]: 크기 지정
class AddFriendButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final double height;
  final double width;

  const AddFriendButton({
    super.key,
    required this.label,
    required this.onTap,
    this.height = 40,
    this.width = 114,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: ShapeDecoration(
          color: const Color(0xFF985F35),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Pretendard'),
        ),
      ),
    );
  }
}
