import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';

/// 🔹 커스텀 텍스트 필드
/// - 온정에서 사용하는 공통 입력 필드 위젯
/// - 입력 가능/불가능 타입 구분, 삭제 아이콘, 스타일 자동 적용
/// - 버튼형 필드(event, date 등)는 readOnly + 커서 비활성화 설정됨
class CustomTextField extends StatelessWidget {
  final TextFieldConfig config; // 구성 정보

  const CustomTextField({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    // 🔹 텍스트 여부, 에러, 포커스 상태 가져오기
    final hasText = config.hasText;
    final isFocused = config.isFocused;
    final isError = config.isError;
    final isLarge = config.isLarge;

    // 🔸 테두리 색상 결정
    final Color borderColor = isError
        ? const Color(0xFFD5584B) // 에러
        : isFocused
            ? const Color(0xFF2A2928) // 포커스
            : const Color(0xFFE9E5E1); // 기본

    // 🔸 텍스트 스타일 정의
    final TextStyle textStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontFamily: 'Pretendard',
      color: const Color(0xFF2A2928),
    );

    // 🔸 내부 패딩
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔹 TextField 영역
          Expanded(
            child: TextField(
              controller: config.controller,
              focusNode: config.focusNode,
              readOnly: config.isReadOnly, // ✅ 입력 가능 여부
              showCursor: config.showCursor, // ✅ 커서 표시 여부
              keyboardType: config.keyboardType,
              inputFormatters: config.formatters,
              maxLines: config.isMultiline ? null : 1,
              maxLength:
                  config.type == TextFieldType.memo ? 200 : config.maxLength,
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
                  ? (context,
                      {required currentLength, required isFocused, maxLength}) {
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

          // 🔹 삭제 아이콘 (입력값 있을 때만 표시)
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
          ]
        ],
      ),
    );
  }
}
