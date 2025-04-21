// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/utils/date/date_formats.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_add/my_event_add_step2_page.dart';
import 'package:flutter_application_onjungapp/viewmodels/my_events_tab/my_event_add_view_model.dart';

class MyEventAddStep1Page extends ConsumerStatefulWidget {
  const MyEventAddStep1Page({super.key});

  @override
  ConsumerState<MyEventAddStep1Page> createState() =>
      _MyEventAddStep1PageState();
}

class _MyEventAddStep1PageState extends ConsumerState<MyEventAddStep1Page> {
  @override
  void dispose() {
    // 페이지 종료 시 컨트롤러 정리
    ref.read(myEventAddViewModelProvider.notifier).disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(myEventAddViewModelProvider); // 상태
    final notifier = ref.read(myEventAddViewModelProvider.notifier); // 메서드 호출용

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // 키보드 닫기
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CustomSubAppBar(title: '경조사 추가'),
              const StepProgressBar(currentStep: 1),
              const SizedBox(height: 24),

              // 안내 문구
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '어떤 경조사인가요?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Pretendard',
                    color: Color(0xFF2A2928),
                    height: 1.36,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 입력 필드 영역
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 경조사 이름
                      const Text('경조사 이름',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Pretendard',
                          )),
                      const SizedBox(height: 8),
                      CustomTextField(
                        config: TextFieldConfig(
                          controller: notifier.titleController,
                          focusNode: notifier.titleFocus,
                          type: TextFieldType.eventTitle,
                          isLarge: true,
                          readOnlyOverride: false,
                          maxLength: 10,
                          onChanged: (_) => setState(() {}),
                          onTap: () => setState(() {}),
                          onClear: () {
                            notifier.titleController.clear();
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${notifier.titleController.text.length}/10자',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFB5B1AA),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 🔹 경조사 종류
                      const Text('경조사',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Pretendard',
                          )),
                      const SizedBox(height: 8),
                      _buildOccasionSelector(vm, notifier),
                      const SizedBox(height: 24),

                      // 🔹 날짜 선택
                      const Text('날짜',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Pretendard',
                          )),
                      const SizedBox(height: 8),
                      _buildDateSelector(vm, notifier),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // 다음 버튼
              BottomFixedButtonContainer(
                child: notifier.isStep1Complete
                    ? BlackFillButton(
                        text: '다음',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MyEventAddStep2Page(),
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

  /// 🔽 경조사 종류 선택 위젯
  Widget _buildOccasionSelector(
      MyEventAddState vm, MyEventAddViewModel notifier) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        GestureDetector(
          onTap: () async {
            await showEventsSelectBottomSheet(
              context: context,
              currentValue: vm.selectedEventType,
              onSelected: (value) async {
                notifier.setEventType(value);
                await Future.delayed(const Duration(milliseconds: 100));
                FocusScope.of(context).unfocus();
              },
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE9E5E1)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              vm.selectedEventType?.label ?? '경조사를 선택해 주세요',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Pretendard',
                color: vm.selectedEventType != null
                    ? const Color(0xFF2A2928)
                    : const Color(0xFFB5B1AA),
              ),
            ),
          ),
        ),
        if (vm.selectedEventType != null)
          IconButton(
            icon: SvgPicture.asset('assets/icons/delete.svg'),
            onPressed: notifier.clearEventType,
          ),
      ],
    );
  }

  /// 🔽 날짜 선택 위젯
  Widget _buildDateSelector(MyEventAddState vm, MyEventAddViewModel notifier) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        GestureDetector(
          onTap: () async {
            final pickedDate = await custom_picker.showDatePickerBottomSheet(
              context: context,
              mode: custom_picker.DatePickerMode.full,
              initialDate: vm.selectedDate,
            );
            if (!mounted) return;
            if (pickedDate != null) {
              notifier.setDate(pickedDate);
              await Future.delayed(const Duration(milliseconds: 100));
              if (mounted) FocusScope.of(context).unfocus();
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE9E5E1)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              vm.selectedDate != null
                  ? formatFullDate(vm.selectedDate!)
                  : '날짜를 선택해 주세요',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Pretendard',
                color: vm.selectedDate != null
                    ? const Color(0xFF2A2928)
                    : const Color(0xFFB5B1AA),
              ),
            ),
          ),
        ),
        if (vm.selectedDate != null)
          IconButton(
            icon: SvgPicture.asset('assets/icons/delete.svg'),
            onPressed: notifier.clearDate,
          ),
      ],
    );
  }
}
