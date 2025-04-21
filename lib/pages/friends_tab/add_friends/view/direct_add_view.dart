// 📁 lib/pages/friends_tab/add_friends/view/direct_add_view.dart

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/components/text_fields/custom_text_field.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';
import 'package:flutter_application_onjungapp/components/buttons/selectable_chip_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/bottom_fixed_button_container.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/disabled_button.dart';
import 'package:flutter_application_onjungapp/components/custom_snack_bar.dart';
import 'package:flutter_application_onjungapp/viewmodels/friends_tab/add/friend_add_view_model.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';

/// 👥 직접 친구 추가 탭
class DirectAddView extends ConsumerStatefulWidget {
  const DirectAddView({super.key});

  @override
  ConsumerState<DirectAddView> createState() => _DirectAddViewState();
}

class _DirectAddViewState extends ConsumerState<DirectAddView> {
  static const String userId = 'test-user'; // TODO: 실제 로그인 UID

  @override
  void dispose() {
    ref.read(friendAddViewModelProvider.notifier).disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(friendAddViewModelProvider);
    final vm = ref.read(friendAddViewModelProvider.notifier);

    // 폼 유효성
    final isValid = vm.isValid;

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
                      // 이름
                      const Text('이름',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      CustomTextField(
                        config: TextFieldConfig(
                          controller: state.nameController,
                          focusNode:
                              state.nameController.selection.baseOffset >= 0
                                  ? FocusNode()
                                  : FocusNode(),
                          type: TextFieldType.name,
                          isLarge: true,
                          onChanged: (_) => setState(() {}),
                          onClear: () => state.nameController.clear(),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 전화번호
                      const Text('전화번호',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      CustomTextField(
                        config: TextFieldConfig(
                          controller: state.phoneController,
                          focusNode: FocusNode(),
                          type: TextFieldType.phone,
                          isLarge: true,
                          onChanged: (_) => setState(() {}),
                          onClear: () => state.phoneController.clear(),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 관계
                      const Text('관계',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: RelationType.values
                            .where((r) => r != RelationType.unset)
                            .map((type) {
                          return SelectableChipButton(
                            label: type.label,
                            isSelected: state.selectedRelation == type,
                            onTap: () {
                              vm.setRelation(type);
                              setState(() {});
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // 메모
                      const Text('메모',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      CustomTextField(
                        config: TextFieldConfig(
                          controller: state.memoController,
                          focusNode: FocusNode(),
                          type: TextFieldType.memo,
                          isLarge: true,
                          onChanged: (_) => setState(() {}),
                          onClear: () => state.memoController.clear(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 저장 버튼
              BottomFixedButtonContainer(
                child: isValid
                    ? BlackFillButton(
                        text: '완료',
                        onTap: () async {
                          await vm.save(userId);
                          showOnjungSnackBar(
                            context,
                            '${state.nameController.text}님이 추가되었습니다.',
                          );
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
}
