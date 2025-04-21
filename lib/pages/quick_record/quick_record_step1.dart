// 📁 lib/pages/quick_record/quick_record_step1_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/method_type.dart';
import 'package:flutter_application_onjungapp/pages/quick_record/quick_record_step2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/bar/step_progress_bar.dart';
import 'package:flutter_application_onjungapp/components/buttons/money_quick_add_button.dart';
import 'package:flutter_application_onjungapp/components/buttons/rounded_toggle_button.dart';
import 'package:flutter_application_onjungapp/components/buttons/selectable_chip_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/bottom_fixed_button_container.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/disabled_button.dart';
import 'package:flutter_application_onjungapp/components/text_fields/custom_text_field.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/pages/search/search_person_page.dart';
import 'package:flutter_application_onjungapp/viewmodels/quick_record/quick_record_view_model.dart';

/// 🏃‍♂️ 빠른 기록 Step1: 보낸/받은 & 친구 선택 + 금액 입력
class QuickRecordStep1Page extends ConsumerStatefulWidget {
  const QuickRecordStep1Page({super.key});

  @override
  ConsumerState<QuickRecordStep1Page> createState() =>
      _QuickRecordStep1PageState();
}

class _QuickRecordStep1PageState extends ConsumerState<QuickRecordStep1Page> {
  final _moneyCtrl = TextEditingController();
  final _moneyFocus = FocusNode();
  final _nameCtrl = TextEditingController();
  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    final vm = ref.read(quickRecordViewModelProvider.notifier);
    final state = ref.read(quickRecordViewModelProvider);

    // 초기 금액 포맷팅
    _moneyCtrl.text = NumberFormat.decimalPattern('ko').format(state.amount);
    // 초기 친구 이름
    _nameCtrl.text = state.selectedFriend?.name ?? '';

    // 금액 변경 리스너
    _moneyCtrl.addListener(() {
      final raw = _moneyCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
      vm.setAmount(int.tryParse(raw) ?? 0);
    });
    _moneyFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _moneyCtrl.dispose();
    _moneyFocus.dispose();
    _nameCtrl.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  Future<void> _selectFriend() async {
    final res = await Navigator.push<Friend>(
      context,
      MaterialPageRoute(builder: (_) => const SearchPersonPage()),
    );
    if (res != null) {
      ref.read(quickRecordViewModelProvider.notifier).selectFriend(res);
      _nameCtrl.text = res.name;
    }
    // 포커스 해제
    await Future.delayed(Duration.zero);
    if (mounted) FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quickRecordViewModelProvider);
    final vm = ref.read(quickRecordViewModelProvider.notifier);

    final isFormValid = state.selectedFriend != null &&
        state.amount > 0 &&
        state.method != null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const CustomSubAppBar(title: '빠른 기록'),
              const StepProgressBar(currentStep: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 송수신 토글
                      RoundedToggleButton(
                        leftText: '보냈어요',
                        rightText: '받았어요',
                        isLeftSelected: state.isSend,
                        onToggle: vm.toggleIsSend,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        state.isSend ? '누구에게 얼마를 보냈나요?' : '누구에게 얼마를 받았나요?',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // 친구 선택
                      const Text(
                        '대상 친구',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        config: TextFieldConfig(
                          controller: _nameCtrl,
                          focusNode: _nameFocus,
                          type: TextFieldType.search,
                          readOnlyOverride: false,
                          onTap: _selectFriend,
                          onClear: () {
                            vm.clearFriend();
                            _nameCtrl.clear();
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      // 주소록 안내
                      if (state.selectedFriend == null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF5E8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '주소록에 있는 친구만 선택할 수 있어요.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF985F35),
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                      const Text(
                        '금액 입력',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        config: TextFieldConfig(
                          controller: _moneyCtrl,
                          focusNode: _moneyFocus,
                          type: TextFieldType.amount,
                          isLarge: true,
                          onChanged: (_) => setState(() {}),
                          onClear: () => _moneyCtrl.clear(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // 빠른 금액 버튼
                      Row(
                        children: [10000, 50000, 100000, 500000].map((amt) {
                          return Expanded(
                            child: Padding(
                              padding:
                                  EdgeInsets.only(right: amt == 500000 ? 0 : 8),
                              child: MoneyQuickAddButton(
                                  label: '+${amt ~/ 10000}만',
                                  onTap: () {
                                    vm.addAmount(amt);
                                    // UI 쪽에선 항상 watch 한 state.amount 를 참조
                                    _moneyCtrl.text = NumberFormat
                                            .decimalPattern('ko')
                                        .format(ref
                                            .read(quickRecordViewModelProvider)
                                            .amount);
                                  }),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '전달 방식',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // 수단 칩
                      Wrap(
                        spacing: 8,
                        children: MethodType.values.map((m) {
                          return SelectableChipButton(
                            label: m.label,
                            isSelected: state.method == m,
                            onTap: () => vm.selectMethod(m),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              BottomFixedButtonContainer(
                child: isFormValid
                    ? BlackFillButton(
                        text: '다음',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const QuickRecordStep2Page(),
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
