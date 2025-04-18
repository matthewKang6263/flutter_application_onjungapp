import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/bar/step_progress_bar.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/bottom_fixed_button_container.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/disabled_button.dart';
import 'package:flutter_application_onjungapp/components/text_fields/custom_text_field.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';
import 'package:flutter_application_onjungapp/components/bottom_sheet/date_picker_bottom_sheet.dart'
    as custom_picker;
import 'package:flutter_application_onjungapp/components/bottom_sheet/events_select_bottom_sheet.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/pages/quick_record/quick_record_step3.dart';
import 'package:flutter_application_onjungapp/viewmodels/quick_record/quick_record_view_model.dart';
import 'package:provider/provider.dart';

class QuickRecordStep2Page extends StatefulWidget {
  final DateTime? initialDate;

  const QuickRecordStep2Page({super.key, this.initialDate});

  @override
  State<QuickRecordStep2Page> createState() => _QuickRecordStep2PageState();
}

class _QuickRecordStep2PageState extends State<QuickRecordStep2Page> {
  final TextEditingController eventController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  /// ✅ 다음 프레임에서 강제 포커스 해제 (키보드 숨기기)
  void forceUnfocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();
    });
  }

  @override
  void initState() {
    super.initState();

    final vm = context.read<QuickRecordViewModel>();

    if (widget.initialDate != null) {
      vm.selectDate(widget.initialDate);
      dateController.text = _formatDate(widget.initialDate!);
    } else if (vm.selectedDate != null) {
      dateController.text = _formatDate(vm.selectedDate!);
    }

    if (vm.selectedEventType != null) {
      eventController.text = vm.selectedEventType!.label;
    }
  }

  @override
  void dispose() {
    eventController.dispose();
    dateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('yyyy년 M월 d일 (E)', 'ko');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuickRecordViewModel>();
    final isNextEnabled =
        vm.selectedEventType != null && vm.selectedDate != null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const CustomSubAppBar(title: '빠른 기록'),
              const StepProgressBar(currentStep: 2),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '참석한 경조사와 날짜를',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          height: 1.36,
                          fontFamily: 'Pretendard',
                          color: Color(0xFF2A2928),
                        ),
                      ),
                      const Text(
                        '알려주세요.',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          height: 1.36,
                          fontFamily: 'Pretendard',
                          color: Color(0xFF2A2928),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '경조사',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        config: TextFieldConfig(
                          controller: eventController,
                          type: TextFieldType.event,
                          readOnlyOverride: true,
                          showCursorOverride: false,
                          onTap: () async {
                            await showEventsSelectBottomSheet(
                              context: context,
                              currentValue: vm.selectedEventType,
                              onSelected: (value) {
                                vm.selectEventType(value);
                                eventController.text = value?.label ?? '';
                                forceUnfocus();
                              },
                            );
                          },
                          onClear: () {
                            vm.selectEventType(null);
                            eventController.clear();
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '날짜',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        config: TextFieldConfig(
                          controller: dateController,
                          type: TextFieldType.date,
                          readOnlyOverride: true,
                          showCursorOverride: false,
                          onTap: () async {
                            final pickedDate =
                                await custom_picker.showDatePickerBottomSheet(
                              context: context,
                              mode: custom_picker.DatePickerMode.full,
                              initialDate: vm.selectedDate,
                            );
                            if (pickedDate != null) {
                              vm.selectDate(pickedDate);
                              dateController.text = _formatDate(pickedDate);
                              forceUnfocus();
                            }
                          },
                          onClear: () {
                            vm.selectDate(null);
                            dateController.clear();
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              BottomFixedButtonContainer(
                child: isNextEnabled
                    ? BlackFillButton(
                        text: '다음',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const QuickRecordStep3Page(),
                            ),
                          );
                        },
                      )
                    : const DisabledButton(text: '다음'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
