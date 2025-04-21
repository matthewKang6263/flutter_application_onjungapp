import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_application_onjungapp/viewmodels/my_events_tab/my_event_add_view_model.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/bar/step_progress_bar.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/bottom_fixed_button_container.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/buttons/add_friend_button.dart';
import 'package:flutter_application_onjungapp/components/text_fields/custom_text_field.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_add/my_event_add_complete_page.dart';

class MyEventAddStep3Page extends ConsumerStatefulWidget {
  const MyEventAddStep3Page({super.key});

  @override
  ConsumerState<MyEventAddStep3Page> createState() =>
      _MyEventAddStep3PageState();
}

class _MyEventAddStep3PageState extends ConsumerState<MyEventAddStep3Page> {
  @override
  void initState() {
    super.initState();
    // 🌸 화환 입력 필드 초기화
    ref.read(myEventAddViewModelProvider.notifier).initFlowerControllers();
  }

  /// ✅ 저장 또는 건너뛰기
  Future<void> _onSubmit({bool skip = false}) async {
    final notifier = ref.read(myEventAddViewModelProvider.notifier);
    const userId = 'test-user'; // TODO: 로그인 연동 시 대체

    if (skip) {
      // 건너뛰는 경우 컨트롤러 비우기
      notifier.initFlowerControllers();
    }

    final event = await notifier.submit(userId);
    if (event != null && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MyEventAddCompletePage(event: event),
        ),
      );
    } else {
      // TODO: 에러 처리
      print('🚨 이벤트 생성 실패');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myEventAddViewModelProvider);
    final notifier = ref.read(myEventAddViewModelProvider.notifier);

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

              // 📝 안내 문구
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

              // ✏️ 이름 입력 필드들
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ...List.generate(state.flowerFriendNames.length, (index) {
                        final controller = notifier.flowerControllers[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 이름 상단 타이틀
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
                                  if (state.flowerFriendNames.length > 1)
                                    GestureDetector(
                                      onTap: () =>
                                          notifier.removeFlowerFriend(index),
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

                              // 텍스트 필드
                              CustomTextField(
                                config: TextFieldConfig(
                                  controller: controller,
                                  type: TextFieldType.name,
                                  isLarge: true,
                                  readOnlyOverride: false,
                                  maxLength: 10,
                                  onChanged: (text) =>
                                      notifier.updateFlowerName(index, text),
                                  onClear: () =>
                                      notifier.clearFlowerName(index),
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

                      // ➕ 추가 버튼
                      GestureDetector(
                        onTap: notifier.addFlowerFriend,
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

              // ✅ 다음 버튼
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
