import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/viewmodels/my_events_tab/my_event_add_view_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/bar/step_progress_bar.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/bottom_fixed_button_container.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/buttons/add_friend_button.dart';
import 'package:flutter_application_onjungapp/components/text_fields/custom_text_field.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_add/my_event_add_complete_page.dart';
import 'package:provider/provider.dart';

class MyEventAddStep3Page extends StatefulWidget {
  const MyEventAddStep3Page({super.key});

  @override
  State<MyEventAddStep3Page> createState() => _MyEventAddStep3PageState();
}

class _MyEventAddStep3PageState extends State<MyEventAddStep3Page> {
  @override
  void initState() {
    super.initState();
    context.read<MyEventAddViewModel>().initFlowerControllers();
  }

  Future<void> _onSubmit({bool skip = false}) async {
    final vm = context.read<MyEventAddViewModel>();
    const userId = 'tempUserId'; // TODO: 실제 로그인 정보로 교체할 것

    if (skip) {
      vm.flowerControllers.clear();
    }

    final myEvent = await vm.submit(userId);
    if (myEvent != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MyEventAddCompletePage(event: myEvent),
        ),
      );
    } else {
      // TODO: 에러 처리 (토스트 등)
      print('🚨 이벤트 생성 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MyEventAddViewModel>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomSubAppBar(title: '경조사 추가'),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const StepProgressBar(currentStep: 3),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '화환을 전달한',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2A2928),
                              height: 1.36,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                          Text(
                            '친구는 누구인가요?',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2A2928),
                              height: 1.36,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                        ],
                      ),
                    ),
                    AddFriendButton(
                      label: '건너뛰기',
                      onTap: () => _onSubmit(skip: true),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ...List.generate(vm.flowerControllers.length, (index) {
                        final controller = vm.flowerControllers[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '친구 ${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2A2928),
                                      fontFamily: 'Pretendard',
                                    ),
                                  ),
                                  if (vm.flowerControllers.length > 1)
                                    GestureDetector(
                                      onTap: () => vm.removeFlowerFriend(index),
                                      child: const Text(
                                        '삭제',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFFB5B1AA),
                                          fontFamily: 'Pretendard',
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                config: TextFieldConfig(
                                  controller: controller,
                                  type: TextFieldType.name,
                                  isLarge: true,
                                  readOnlyOverride: false,
                                  maxLength: 10,
                                  onChanged: (text) =>
                                      vm.updateFlowerName(index, text),
                                  onClear: () => vm.clearFlowerName(index),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${controller.text.length}/10자',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFB5B1AA),
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      GestureDetector(
                        onTap: vm.addFlowerFriend,
                        child: SvgPicture.asset(
                          'assets/icons/btn_add_lg.svg',
                          width: 48,
                          height: 48,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              BottomFixedButtonContainer(
                child: BlackFillButton(
                  text: '다음',
                  onTap: _onSubmit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
