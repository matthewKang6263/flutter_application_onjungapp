import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
import 'package:flutter_application_onjungapp/utils/date_utils.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_add/my_event_add_step2_page.dart';
import 'package:flutter_application_onjungapp/viewmodels/my_events_tab/my_event_add_view_model.dart';

class MyEventAddStep1Page extends StatelessWidget {
  const MyEventAddStep1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyEventAddViewModel>(
      create: (_) => MyEventAddViewModel(),
      child: const _MyEventAddStep1Body(),
    );
  }
}

class _MyEventAddStep1Body extends StatefulWidget {
  const _MyEventAddStep1Body();

  @override
  State<_MyEventAddStep1Body> createState() => _MyEventAddStep1BodyState();
}

class _MyEventAddStep1BodyState extends State<_MyEventAddStep1Body> {
  @override
  void dispose() {
    final vm = context.read<MyEventAddViewModel>();
    vm.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MyEventAddViewModel>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CustomSubAppBar(title: '경조사 추가'),
              const StepProgressBar(currentStep: 1),
              const SizedBox(height: 24),
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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('경조사 이름',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Pretendard',
                          )),
                      const SizedBox(height: 8),
                      CustomTextField(
                        config: TextFieldConfig(
                          controller: vm.titleController,
                          focusNode: vm.titleFocus,
                          type: TextFieldType.eventTitle,
                          isLarge: true,
                          readOnlyOverride: false,
                          maxLength: 10,
                          onChanged: (_) => setState(() {}),
                          onTap: () => setState(() {}),
                          onClear: () {
                            vm.titleController.clear();
                            setState(() {});
                          },
                        ),
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${vm.titleController.text.length}/10자',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFB5B1AA),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text('경조사',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Pretendard',
                          )),
                      const SizedBox(height: 8),
                      _buildOccasionSelector(vm),
                      const SizedBox(height: 24),
                      const Text('날짜',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Pretendard',
                          )),
                      const SizedBox(height: 8),
                      _buildDateSelector(vm),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              BottomFixedButtonContainer(
                child: vm.isStep1Complete
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

  Widget _buildOccasionSelector(MyEventAddViewModel vm) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        GestureDetector(
          onTap: () async {
            await showEventsSelectBottomSheet(
              context: context,
              currentValue: vm.selectedEventType,
              onSelected: (value) async {
                vm.setEventType(value);
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
            onPressed: vm.clearEventType,
          ),
      ],
    );
  }

  Widget _buildDateSelector(MyEventAddViewModel vm) {
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
              vm.setDate(pickedDate);
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
            onPressed: vm.clearDate,
          ),
      ],
    );
  }
}
