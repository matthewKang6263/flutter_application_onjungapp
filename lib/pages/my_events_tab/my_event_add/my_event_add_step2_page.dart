// 📁 lib/pages/my_events_tab/my_event_add/my_event_add_step2_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/bar/step_progress_bar.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/bottom_fixed_button_container.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/disabled_button.dart';
import 'package:flutter_application_onjungapp/components/dividers/thick_divider.dart';
import 'package:flutter_application_onjungapp/components/wrappers/cupertino_touch_wrapper.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_add/my_event_add_step3_page.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/widgets/my_event_friend_list_item.dart';
import 'package:flutter_application_onjungapp/pages/search/search_event_person_page.dart';
import 'package:flutter_application_onjungapp/viewmodels/my_events_tab/my_event_add_view_model.dart';

class MyEventAddStep2Page extends ConsumerStatefulWidget {
  const MyEventAddStep2Page({super.key});

  @override
  ConsumerState<MyEventAddStep2Page> createState() =>
      _MyEventAddStep2PageState();
}

class _MyEventAddStep2PageState extends ConsumerState<MyEventAddStep2Page> {
  @override
  void initState() {
    super.initState();
    ref.read(myEventAddViewModelProvider.notifier).loadFriends('test-user');
  }

  Future<void> _openSearchPage() async {
    final vm = ref.read(myEventAddViewModelProvider);
    final notifier = ref.read(myEventAddViewModelProvider.notifier);

    final updated = await Navigator.push<Set<String>>(
      context,
      MaterialPageRoute(
        builder: (_) => SearchEventPersonPage(
          initialSelectedFriendIds: vm.selectedFriendIds,
          onComplete: (result) => Navigator.pop(context, result),
        ),
      ),
    );

    if (updated != null) {
      notifier.setSelectedFriendIds(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(myEventAddViewModelProvider);
    final notifier = ref.read(myEventAddViewModelProvider.notifier);

    if (vm.isFriendLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final friends = vm.friends;
    final selected = vm.selectedFriendIds;
    final isNextEnabled = selected.isNotEmpty;
    final isAllSelected = selected.length == friends.length;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomSubAppBar(title: '경조사 추가'),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const StepProgressBar(currentStep: 2),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '경조사에 마음을 전달한',
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
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 49,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '선택한 친구 ${selected.length}명 / 총 ${friends.length}명',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2A2928),
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      CupertinoTouchWrapper(
                        onTap: _openSearchPage,
                        child: SvgPicture.asset(
                          'assets/icons/search.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const ThickDivider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 49,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 120,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '이름',
                                style: TextStyle(
                                  color: Color(0xFF985F35),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Center(
                              child: Text(
                                '나와의 관계',
                                style: TextStyle(
                                  color: Color(0xFF985F35),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CupertinoTouchWrapper(
                                  onTap: notifier.toggleSelectAll,
                                  child: Row(
                                    children: [
                                      Text(
                                        isAllSelected ? '전체 해제' : '전체 선택',
                                        style: const TextStyle(
                                          color: Color(0xFF985F35),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Pretendard',
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      SvgPicture.asset(
                                        isAllSelected
                                            ? 'assets/icons/selected.svg'
                                            : 'assets/icons/select.svg',
                                        width: 24,
                                        height: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(height: 1, color: const Color(0xFFE9E5E1)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: friends.length,
                  separatorBuilder: (_, __) =>
                      Container(height: 1, color: const Color(0xFFE9E5E1)),
                  itemBuilder: (_, index) {
                    final friend = friends[index];
                    final isSelected = selected.contains(friend.id);
                    return MyEventFriendListItem(
                      friend: friend,
                      isSelected: isSelected,
                      onTap: () => notifier.toggleFriend(friend.id),
                    );
                  },
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
                              builder: (_) => const MyEventAddStep3Page(),
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
