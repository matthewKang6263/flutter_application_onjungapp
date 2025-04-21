// 📁 lib/pages/quick_record/quick_record_step3_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/bar/step_progress_bar.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/bottom_fixed_button_container.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/disabled_button.dart';
import 'package:flutter_application_onjungapp/components/buttons/selectable_chip_button.dart';
import 'package:flutter_application_onjungapp/components/text_fields/custom_text_field.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';
import 'package:flutter_application_onjungapp/models/enums/attendance_type.dart';
import 'package:flutter_application_onjungapp/viewmodels/quick_record/quick_record_view_model.dart';
import 'package:flutter_application_onjungapp/viewmodels/auth/user_view_model.dart';

/// 📝 빠른 기록 Step3: 참석 여부 + 메모
class QuickRecordStep3Page extends ConsumerStatefulWidget {
  const QuickRecordStep3Page({Key? key}) : super(key: key);

  @override
  ConsumerState<QuickRecordStep3Page> createState() =>
      _QuickRecordStep3PageState();
}

class _QuickRecordStep3PageState extends ConsumerState<QuickRecordStep3Page> {
  final _memoCtrl = TextEditingController();
  final _memoFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _memoCtrl.text = ref.read(quickRecordViewModelProvider).memo;
  }

  @override
  void dispose() {
    _memoCtrl.dispose();
    _memoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quickRecordViewModelProvider);
    final vm = ref.read(quickRecordViewModelProvider.notifier);
    final userId = ref.read(userViewModelProvider).uid;

    final canSubmit = state.attendance != null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const CustomSubAppBar(title: '빠른 기록'),
              const StepProgressBar(currentStep: 3),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '참석 여부를 선택해 주세요.',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 참석 여부 칩
                      Row(
                        children: AttendanceType.values.map((t) {
                          return Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: SelectableChipButton(
                                label: t.label,
                                isSelected: state.attendance == t,
                                onTap: () => vm.selectAttendance(t),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '메모 (선택)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        config: TextFieldConfig(
                          controller: _memoCtrl,
                          focusNode: _memoFocus,
                          type: TextFieldType.memo,
                          isLarge: true,
                          onChanged: vm.updateMemo,
                          onClear: () {
                            _memoCtrl.clear();
                            vm.clearMemo();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BottomFixedButtonContainer(
                child: canSubmit
                    ? BlackFillButton(
                        text: '완료',
                        onTap: () async {
                          if (userId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('로그인 후 이용해주세요.'),
                              ),
                            );
                            return;
                          }
                          try {
                            await vm.submit(userId);
                            vm.reset();
                            Navigator.popUntil(context, (r) => r.isFirst);
                          } catch (_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('저장에 실패했습니다.'),
                              ),
                            );
                          }
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
