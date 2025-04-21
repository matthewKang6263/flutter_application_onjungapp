// lib/components/text_fields/custom_text_field.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';

/// 🔹 온정 공통 입력 필드 위젯
/// - 읽기전용/입력 모드 구분
/// - 삭제 아이콘 표시
/// - 포커스·에러 스타일 자동 적용
class CustomTextField extends StatelessWidget {
  final TextFieldConfig config;
  const CustomTextField({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final bool hasText = config.hasText;
    final bool isFocused = config.isFocused;
    final bool isError = config.isError;
    final bool isLarge = config.isLarge;

    // ● 테두리 색상 결정
    final Color borderColor = isError
        ? const Color(0xFFD5584B) // 에러 시 빨강
        : isFocused
            ? const Color(0xFF2A2928) // 포커스 시 진한 회색
            : const Color(0xFFE9E5E1); // 기본 연한 회색

    // ● 텍스트 스타일
    final TextStyle textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontFamily: 'Pretendard',
      color: Color(0xFF2A2928),
    );

    // ● 내부 여백
    final EdgeInsets padding = isLarge
        ? const EdgeInsets.all(16)
        : const EdgeInsets.symmetric(horizontal: 16, vertical: 12);

    return Container(
      padding: padding,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(width: 1, color: borderColor),
        ),
      ),
      child: Row(
        children: [
          // ◼︎ 입력 필드
          Expanded(
            child: TextField(
              controller: config.controller,
              focusNode: config.focusNode,
              readOnly: config.isReadOnly,
              showCursor: config.showCursor,
              keyboardType: config.keyboardType,
              inputFormatters: config.formatters,
              maxLines: config.isMultiline ? null : 1,
              maxLength: config.type == TextFieldType.memo
                  ? (config.maxLength ?? 200)
                  : config.maxLength,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              onTap: config.onTap,
              onChanged: config.onChanged,
              style: textStyle,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: config.hintText,
                hintStyle: textStyle.copyWith(color: const Color(0xFFB5B1AA)),
                contentPadding: EdgeInsets.zero,
                counterText: config.type == TextFieldType.memo ? null : '',
              ),
              buildCounter: config.type == TextFieldType.memo
                  ? (BuildContext context,
                      {required int currentLength,
                      required bool isFocused,
                      int? maxLength}) {
                      return Text(
                        '$currentLength / $maxLength',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFB5B1AA),
                          fontFamily: 'Pretendard',
                        ),
                      );
                    }
                  : null,
            ),
          ),

          // ◼︎ 삭제 아이콘 (입력값이 있을 때만)
          if (hasText && config.onClear != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: config.onClear,
              child: SvgPicture.asset(
                'assets/icons/delete.svg',
                width: 16,
                height: 16,
                color: const Color(0xFFB5B1AA),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
