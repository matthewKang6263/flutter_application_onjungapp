import 'package:flutter/material.dart';

/// 버튼 컴포넌트
/// 고정 너비 114, 배경색 #985F35, 텍스트 스타일은 피그마 기준 적용됩니다.
/// [label] 파라미터로 버튼에 표시할 텍스트를 지정할 수 있습니다.
/// [height]를 지정하면 버튼 높이를 커스터마이징할 수 있습니다. (기본값: 40)
class AddFriendButton extends StatelessWidget {
  final String label; // 버튼에 표시할 텍스트
  final VoidCallback onTap; // 버튼 클릭 시 동작
  final double height; // 버튼 높이 (기본값 40)
  final double width; // 버튼 높이 (기본값 114)

  const AddFriendButton({
    super.key,
    required this.label,
    required this.onTap,
    this.height = 40, // 기본값 설정
    this.width = 114, // 기본값 설정
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Pretendard',
          ),
        ),
      ),
    );
  }
}
