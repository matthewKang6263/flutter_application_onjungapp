import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/viewmodels/auth/user_view_model.dart';
import 'package:provider/provider.dart';
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

class QuickRecordStep3Page extends StatefulWidget {
  const QuickRecordStep3Page({super.key});

  @override
  State<QuickRecordStep3Page> createState() => _QuickRecordStep3PageState();
}

class _QuickRecordStep3PageState extends State<QuickRecordStep3Page> {
  final TextEditingController _memoController = TextEditingController();
  final FocusNode _memoFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final vm = context.read<QuickRecordViewModel>();
    _memoController.text = vm.memo;
  }

  @override
  void dispose() {
    _memoController.dispose();
    _memoFocusNode.dispose();
    super.dispose();
  }

  void goToHome(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuickRecordViewModel>();
    final userId = context.watch<UserViewModel>().uid;
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
                        '더 기록할 내용이 있다면',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Pretendard',
                          color: Color(0xFF2A2928),
                          height: 1.36,
                        ),
                      ),
                      const Text(
                        '알려주세요.',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Pretendard',
                          color: Color(0xFF2A2928),
                          height: 1.36,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 🔸 참석 여부
                      const Text(
                        '참석 여부',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: AttendanceType.values.map((type) {
                          return Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: SelectableChipButton(
                                label: type.label,
                                isSelected: vm.attendance == type,
                                onTap: () => vm.selectAttendance(type),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // 🔸 메모 필드
                      const Text(
                        '메모',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        config: TextFieldConfig(
                          controller: _memoController,
                          focusNode: _memoFocusNode,
                          type: TextFieldType.memo,
                          isLarge: true,
                          readOnlyOverride: false,
                          onTap: () => setState(() {}),
                          onChanged: vm.updateMemo,
                          onClear: () {
                            _memoController.clear();
                            vm.clearMemo();
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // 🔸 하단 버튼
              BottomFixedButtonContainer(
                child: vm.attendance != null
                    ? BlackFillButton(
                        text: '확인',
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
                            goToHome(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('저장에 실패했어요. 다시 시도해주세요.'),
                              ),
                            );
                          }
                        })
                    : const DisabledButton(text: '확인'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
