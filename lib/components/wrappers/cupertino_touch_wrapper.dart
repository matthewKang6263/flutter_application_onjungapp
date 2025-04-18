import 'package:flutter/material.dart';

/// 🍎 iOS 스타일 터치 피드백을 주는 공통 Wrapper
/// - 눌렀을 때 회색 배경 (F2F2F2)
/// - 기본값: 전체 영역 터치 가능
/// - iOS `InkWell` 대체용으로 사용
class CupertinoTouchWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;

  const CupertinoTouchWrapper({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.borderRadius,
    this.padding,
  });

  @override
  State<CupertinoTouchWrapper> createState() => _CupertinoTouchWrapperState();
}

class _CupertinoTouchWrapperState extends State<CupertinoTouchWrapper> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed != value) {
      setState(() => _isPressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final decorated = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: _isPressed ? const Color(0xFFF2F2F2) : Colors.transparent,
        borderRadius: widget.borderRadius,
      ),
      child: widget.child,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: widget.padding != null
          ? Padding(padding: widget.padding!, child: decorated)
          : decorated,
    );
  }
}
