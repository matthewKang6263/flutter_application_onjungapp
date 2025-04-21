// lib/components/text_fields/text_field_config.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';

/// 🔹 CustomTextField 설정 객체
/// - 컨트롤러, 포커스, 타입, 에러상태, 최대길이 등 관리
class TextFieldConfig {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextFieldType type;
  final bool isLarge; // 큰 필드 여부
  final bool isError; // 에러 상태 여부
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final ValueChanged<String>? onChanged;
  final bool readOnlyOverride; // true면 항상 입력 허용
  final bool? showCursorOverride; // 커서 표시 강제 여부
  final int? maxLength; // 최대 글자 수

  const TextFieldConfig({
    required this.controller,
    required this.type,
    this.focusNode,
    this.isLarge = true,
    this.isError = false,
    this.onTap,
    this.onClear,
    this.onChanged,
    this.readOnlyOverride = false,
    this.showCursorOverride,
    this.maxLength,
  });

  /// ● 읽기 전용 여부 결정
  bool get isReadOnly => readOnlyOverride ? false : !type.isInputEnabled;

  /// ● 커서 표시 여부 결정
  bool get showCursor => showCursorOverride ?? type.isInputEnabled;

  /// ● 힌트 텍스트
  String get hintText => type.hintText;

  /// ● 키보드 타입
  TextInputType get keyboardType => type.keyboardType;

  /// ● 입력 포맷터 리스트
  List<TextInputFormatter> get formatters => type.inputFormatters;

  /// ● 멀티라인 여부
  bool get isMultiline => type.isMultiline;

  /// ● 현재 입력값 존재 여부
  bool get hasText => controller.text.trim().isNotEmpty;

  /// ● 포커스 상태
  bool get isFocused => focusNode?.hasFocus ?? false;
}
