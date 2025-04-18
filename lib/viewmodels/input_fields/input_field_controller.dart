// 📁 lib/viewmodels/input_fields/input_field_controller.dart

import 'package:flutter/material.dart';

/// 🔹 공통 입력 필드 컨트롤러
/// - 각 입력 필드에 대한 TextEditingController, FocusNode 관리
/// - dispose 처리가 필요한 필드들을 일괄 관리
class InputFieldController {
  final TextEditingController controller;
  final FocusNode focusNode;

  InputFieldController()
      : controller = TextEditingController(),
        focusNode = FocusNode();

  /// 입력값 반환
  String get text => controller.text;

  /// 입력값 초기화
  void clear() => controller.clear();

  /// 포커스 여부 반환
  bool get hasFocus => focusNode.hasFocus;

  /// 리소스 해제
  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }
}

/// 🔹 여러 필드를 사용하는 경우를 위한 그룹 컨트롤러 예시
/// - 필요 시 페이지 단위로 커스텀 컨트롤러 정의 가능
class FriendProfileFieldController {
  final InputFieldController nameField = InputFieldController();
  final InputFieldController phoneField = InputFieldController();
  final InputFieldController memoField = InputFieldController();

  void dispose() {
    nameField.dispose();
    phoneField.dispose();
    memoField.dispose();
  }
}

class EventRecordFieldController {
  final InputFieldController amountField = InputFieldController();
  final InputFieldController memoField = InputFieldController();

  void dispose() {
    amountField.dispose();
    memoField.dispose();
  }
}
