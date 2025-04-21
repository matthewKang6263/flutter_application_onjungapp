// 📁 lib/pages/friends_tab/detail_friends/view/friends_detail_profile_edit_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/dividers/thin_divider.dart';
import 'package:flutter_application_onjungapp/components/text_fields/custom_text_field.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';
import 'package:flutter_application_onjungapp/components/buttons/selectable_chip_button.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';

/// 📄 친구 상세 프로필 - 편집 모드 뷰
class FriendsDetailProfileEditView extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController memoController;
  final FocusNode nameFocus, phoneFocus, memoFocus;
  final RelationType selectedRelation;
  final ValueChanged<RelationType> onRelationChanged;
  final VoidCallback onNameClear, onPhoneClear, onMemoClear;

  const FriendsDetailProfileEditView({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.memoController,
    required this.nameFocus,
    required this.phoneFocus,
    required this.memoFocus,
    required this.selectedRelation,
    required this.onRelationChanged,
    required this.onNameClear,
    required this.onPhoneClear,
    required this.onMemoClear,
  });

  @override
  Widget build(BuildContext context) {
    // unset 타입 제외
    final types =
        RelationType.values.where((t) => t != RelationType.unset).toList();

    return Column(
      children: [
        const SizedBox(height: 24),

        // ── 이름 입력
        _buildFieldSection(
          label: '이름',
          centerLabel: true,
          child: CustomTextField(
            config: TextFieldConfig(
              controller: nameController,
              focusNode: nameFocus,
              type: TextFieldType.name,
              isLarge: false,
              onChanged: (_) {},
              onClear: onNameClear,
            ),
          ),
        ),
        const ThinDivider(),

        // ── 전화번호 입력
        _buildFieldSection(
          label: '전화번호',
          centerLabel: true,
          child: CustomTextField(
            config: TextFieldConfig(
              controller: phoneController,
              focusNode: phoneFocus,
              type: TextFieldType.phone,
              isLarge: false,
              onChanged: (_) {},
              onClear: onPhoneClear,
            ),
          ),
        ),
        const ThinDivider(),

        // ── 관계 선택
        _buildFieldSection(
          label: '관계',
          child: Column(
            children: [
              _buildChipRow(types.sublist(0, 3)),
              const SizedBox(height: 8),
              _buildChipRow(types.sublist(3)),
            ],
          ),
        ),
        const ThinDivider(),

        // ── 메모 입력
        _buildFieldSection(
          label: '메모',
          alignTop: true,
          child: CustomTextField(
            config: TextFieldConfig(
              controller: memoController,
              focusNode: memoFocus,
              type: TextFieldType.memo,
              isLarge: false,
              onChanged: (_) {},
              onClear: onMemoClear,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  /// 공통 입력 섹션
  Widget _buildFieldSection({
    required String label,
    required Widget child,
    bool centerLabel = false,
    bool alignTop = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment:
            alignTop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Pretendard',
                color: Color(0xFF2A2928),
              ),
              textAlign: centerLabel ? TextAlign.center : TextAlign.start,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(child: child),
        ],
      ),
    );
  }

  /// 칩 버튼 가로 리스트
  Widget _buildChipRow(List<RelationType> types) {
    return Row(
      children: types.map((type) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SelectableChipButton(
              label: type.label,
              isSelected: selectedRelation == type,
              onTap: () => onRelationChanged(type),
            ),
          ),
        );
      }).toList(),
    );
  }
}
