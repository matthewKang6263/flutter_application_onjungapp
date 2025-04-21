// 📁 lib/viewmodels/input_fields/input_field_controller.dart

import 'package:flutter/material.dart';

/// 🔹 단일 입력 필드 컨트롤러
/// - TextEditingController와 FocusNode를 묶어 관리
/// - clear(), dispose() 등 편의 메서드 제공
class InputFieldController {
  final TextEditingController controller;
  final FocusNode focusNode;

  InputFieldController()
      : controller = TextEditingController(),
        focusNode = FocusNode();

  /// ▪︎ 현재 텍스트 반환
  String get text => controller.text;

  /// ▪︎ 텍스트 초기화
  void clear() => controller.clear();

  /// ▪︎ 포커스 상태
  bool get hasFocus => focusNode.hasFocus;

  /// ▪︎ 리소스 해제
  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }
}

/// 🔹 친구 프로필 페이지용 필드 그룹 컨트롤러
class FriendProfileFieldController {
  final InputFieldController name = InputFieldController();
  final InputFieldController phone = InputFieldController();
  final InputFieldController memo = InputFieldController();

  void dispose() {
    name.dispose();
    phone.dispose();
    memo.dispose();
  }
}

/// 🔹 이벤트 기록 입력 페이지용 필드 그룹 컨트롤러
class EventRecordFieldController {
  final InputFieldController amount = InputFieldController();
  final InputFieldController memo = InputFieldController();

  void dispose() {
    amount.dispose();
    memo.dispose();
  }
}
