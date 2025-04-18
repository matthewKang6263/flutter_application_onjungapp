import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_onjungapp/components/bottom_buttons/bottom_fixed_button_container.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/disabled_button.dart';
import 'package:flutter_application_onjungapp/components/buttons/selectable_chip_button.dart';
import 'package:flutter_application_onjungapp/components/custom_snack_bar.dart';
import 'package:flutter_application_onjungapp/components/text_fields/custom_text_field.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/viewmodels/friends_tab/friend_add_edit_view_model.dart';

/// 📋 직접 친구 추가 탭
class DirectAddView extends StatelessWidget {
  const DirectAddView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FriendAddEditViewModel(),
      child: const _DirectAddContent(),
    );
  }
}

class _DirectAddContent extends StatefulWidget {
  const _DirectAddContent();

  @override
  State<_DirectAddContent> createState() => _DirectAddContentState();
}

class _DirectAddContentState extends State<_DirectAddContent> {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _memoFocus = FocusNode();

  final List<String> relations = ['가족', '친척', '친구', '지인', '직장', '기타'];
  final String userId = 'test-user'; // TODO: Replace with actual user ID

  @override
  void dispose() {
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _memoFocus.dispose();
    context.read<FriendAddEditViewModel>().disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FriendAddEditViewModel>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle('이름'),
                      CustomTextField(
                        config: TextFieldConfig(
                          controller: vm.nameController,
                          focusNode: _nameFocus,
                          type: TextFieldType.name,
                          isLarge: true,
                          onChanged: (_) => setState(() {}),
                          onClear: () =>
                              setState(() => vm.nameController.clear()),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildTitle('전화번호'),
                      CustomTextField(
                        config: TextFieldConfig(
                          controller: vm.phoneController,
                          focusNode: _phoneFocus,
                          type: TextFieldType.phone,
                          isLarge: true,
                          onChanged: (_) => setState(() {}),
                          onClear: () =>
                              setState(() => vm.phoneController.clear()),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildTitle('관계'),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: relations.map((label) {
                          return SizedBox(
                            width: (MediaQuery.of(context).size.width -
                                    16 * 2 -
                                    8 * 2) /
                                3,
                            child: SelectableChipButton(
                              label: label,
                              isSelected: vm.selectedRelation.label == label,
                              onTap: () => vm.setRelation(
                                RelationType.values.firstWhere(
                                  (r) => r.label == label,
                                  orElse: () => RelationType.etc,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      _buildTitle('메모'),
                      CustomTextField(
                        config: TextFieldConfig(
                          controller: vm.memoController,
                          focusNode: _memoFocus,
                          type: TextFieldType.memo,
                          isLarge: true,
                          onChanged: (_) => setState(() {}),
                          onClear: () =>
                              setState(() => vm.memoController.clear()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BottomFixedButtonContainer(
                child: vm.isValid
                    ? BlackFillButton(
                        text: '완료',
                        onTap: () async {
                          await vm.save(userId);
                          showOnjungSnackBar(context,
                              '${vm.nameController.text}님이 친구에 추가되었어요');
                          vm.clear();
                          setState(() {});
                        },
                      )
                    : const DisabledButton(text: '완료'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            fontFamily: 'Pretendard',
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
