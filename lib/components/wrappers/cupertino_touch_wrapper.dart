// lib/components/wrappers/cupertino_touch_wrapper.dart

import 'package:flutter/material.dart';

/// 🍎 iOS 스타일 터치 피드백 래퍼
/// - tap down 시 회색 배경(0xFFF2F2F2) 표시
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
  bool _pressed = false;

  void _setPressed(bool v) => setState(() => _pressed = v);

  @override
  Widget build(BuildContext context) {
    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
          color: _pressed ? const Color(0xFFF2F2F2) : Colors.transparent,
          borderRadius: widget.borderRadius),
      child: widget.child,
    );

    final wrapped = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: widget.padding != null
          ? Padding(padding: widget.padding!, child: content)
          : content,
    );

    return wrapped;
  }
}
