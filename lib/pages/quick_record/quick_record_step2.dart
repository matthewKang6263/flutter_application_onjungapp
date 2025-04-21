// 📁 lib/pages/quick_record/quick_record_step2_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/pages/quick_record/quick_record_step3.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/bar/step_progress_bar.dart';
import 'package:flutter_application_onjungapp/components/text_fields/custom_text_field.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/bottom_fixed_button_container.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/disabled_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_sheet/date_picker_bottom_sheet.dart'
    as custom_picker;
import 'package:flutter_application_onjungapp/components/bottom_sheet/events_select_bottom_sheet.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/viewmodels/quick_record/quick_record_view_model.dart';

/// 🗓 빠른 기록 Step2: 경조사 종류 & 날짜 선택
class QuickRecordStep2Page extends ConsumerStatefulWidget {
  const QuickRecordStep2Page({super.key});

  @override
  ConsumerState<QuickRecordStep2Page> createState() =>
      _QuickRecordStep2PageState();
}

class _QuickRecordStep2PageState extends ConsumerState<QuickRecordStep2Page> {
  final _eventCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = ref.read(quickRecordViewModelProvider);

    // 기존 선택값 반영
    if (state.eventType != null) {
      _eventCtrl.text = state.eventType!.label;
    }
    if (state.date != null) {
      _dateCtrl.text = DateFormat('yyyy년 M월 d일 (E)', 'ko').format(state.date!);
    }
  }

  @override
  void dispose() {
    _eventCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quickRecordViewModelProvider);
    final vm = ref.read(quickRecordViewModelProvider.notifier);
    final canNext = state.eventType != null && state.date != null;

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
                        '참석한 경조사와 날짜를 알려주세요.',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '경조사 종류',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        config: TextFieldConfig(
                          controller: _eventCtrl,
                          type: TextFieldType.event,
                          readOnlyOverride: true,
                          onTap: () async {
                            await showEventsSelectBottomSheet(
                              context: context,
                              currentValue: state.eventType,
                              onSelected: (evt) {
                                vm.selectEventType(evt);
                                _eventCtrl.text = evt?.label ?? '';
                              },
                            );
                          },
                          onClear: () {
                            vm.selectEventType(null);
                            _eventCtrl.clear();
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '날짜',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        config: TextFieldConfig(
                          controller: _dateCtrl,
                          type: TextFieldType.date,
                          readOnlyOverride: true,
                          onTap: () async {
                            final sel =
                                await custom_picker.showDatePickerBottomSheet(
                              context: context,
                              mode: custom_picker.DatePickerMode.full,
                              initialDate: state.date,
                            );
                            if (sel != null) {
                              vm.selectDate(sel);
                              _dateCtrl.text =
                                  DateFormat('yyyy년 M월 d일 (E)', 'ko')
                                      .format(sel);
                            }
                          },
                          onClear: () {
                            vm.selectDate(null);
                            _dateCtrl.clear();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BottomFixedButtonContainer(
                child: canNext
                    ? BlackFillButton(
                        text: '다음',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const QuickRecordStep3Page()),
                        ),
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
