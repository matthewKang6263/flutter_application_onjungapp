// 📁 lib/pages/quick_record/quick_record_step1_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';
import 'package:flutter_application_onjungapp/utils/validators.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/bottom_fixed_button_container.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/disabled_button.dart';
import 'package:flutter_application_onjungapp/components/buttons/money_quick_add_button.dart';
import 'package:flutter_application_onjungapp/components/buttons/rounded_toggle_button.dart';
import 'package:flutter_application_onjungapp/components/buttons/selectable_chip_button.dart';
import 'package:flutter_application_onjungapp/components/bar/step_progress_bar.dart';
import 'package:flutter_application_onjungapp/components/tag_label.dart';
import 'package:flutter_application_onjungapp/components/text_fields/custom_text_field.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';
import 'package:flutter_application_onjungapp/models/enums/method_type.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/pages/quick_record/quick_record_step2.dart';
import 'package:flutter_application_onjungapp/pages/search/search_person_page.dart';
import 'package:flutter_application_onjungapp/viewmodels/quick_record/quick_record_view_model.dart';

class QuickRecordStep1Page extends StatefulWidget {
  final String? initialName;
  final DateTime? initialDate;

  const QuickRecordStep1Page({super.key, this.initialName, this.initialDate});

  @override
  State<QuickRecordStep1Page> createState() => _QuickRecordStep1PageState();
}

class _QuickRecordStep1PageState extends State<QuickRecordStep1Page> {
  final TextEditingController moneyController = TextEditingController();
  final FocusNode moneyFocusNode = FocusNode();

  final TextEditingController nameController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final vm = context.read<QuickRecordViewModel>();
    moneyController.text = NumberFormat('#,###').format(vm.amount);
    nameController.text = vm.selectedFriend?.name ?? '';

    moneyController.addListener(() {
      final raw = moneyController.text.replaceAll(RegExp(r'[^0-9]'), '');
      final parsed = int.tryParse(raw) ?? 0;
      vm.setAmount(parsed);
    });

    moneyFocusNode.addListener(() => setState(() {}));
  }

  Future<void> selectFriend() async {
    final result = await Navigator.push<Friend>(
      context,
      MaterialPageRoute(builder: (_) => const SearchPersonPage()),
    );

    if (result != null) {
      context.read<QuickRecordViewModel>().selectFriend(result);
      nameController.text = result.name;
    }

    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    moneyController.dispose();
    moneyFocusNode.dispose();
    nameController.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuickRecordViewModel>();
    final isSend = vm.isSend;
    final selectedFriend = vm.selectedFriend;
    final amount = vm.amount;
    final selectedMethod = vm.selectedMethod;

    final isFormValid =
        selectedFriend != null && amount > 0 && selectedMethod != null;

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
                      RoundedToggleButton(
                        leftText: '보냈어요',
                        rightText: '받았어요',
                        isLeftSelected: isSend,
                        onToggle: (isLeft) => vm.toggleIsSend(isLeft),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        isSend
                            ? '누구에게 얼마를 보냈는지\n입력해 주세요.'
                            : '누구에게 얼마를 받았는지\n입력해 주세요.',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          height: 1.36,
                          color: Color(0xFF2A2928),
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        isSend ? '받으신 분' : '보내신 분',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        config: TextFieldConfig(
                          controller: nameController,
                          focusNode: nameFocusNode,
                          type: TextFieldType.search,
                          readOnlyOverride: false,
                          showCursorOverride: false,
                          onTap: selectFriend,
                          onClear: () {
                            vm.clearFriend();
                            nameController.clear();
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (selectedFriend == null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF5E8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/notice.svg',
                                width: 16,
                                height: 16,
                                color: const Color(0xFF985F35),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '주소록에 존재하는 분만 선택이 가능해요',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF985F35),
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Row(
                          children: [
                            TagLabel.fromRelationType(
                                selectedFriend.relation ?? RelationType.etc),
                            const SizedBox(width: 4),
                            Text(
                              formatPhoneNumber(selectedFriend.phone ?? ''),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2A2928),
                                fontFamily: 'Pretendard',
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 24),
                      Text(
                        isSend ? '보낸 금액(원)' : '받은 금액(원)',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        config: TextFieldConfig(
                          controller: moneyController,
                          focusNode: moneyFocusNode,
                          type: TextFieldType.amount,
                          isLarge: true,
                          readOnlyOverride: false,
                          onTap: () => setState(() {}),
                          onChanged: (_) => setState(() {}),
                          onClear: () => moneyController.clear(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: List.generate(4, (i) {
                          final labels = ['+1만', '+5만', '+10만', '+50만'];
                          final values = [10000, 50000, 100000, 500000];
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: i == 0 ? 0 : 4,
                                right: i == 3 ? 0 : 4,
                              ),
                              child: MoneyQuickAddButton(
                                label: labels[i],
                                onTap: () {
                                  vm.addAmount(values[i]);
                                  moneyController.text =
                                      NumberFormat('#,###').format(vm.amount);
                                },
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: const [
                          Text(
                            '전달한 방식',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '(*선물의 가격대를 금액으로 활용 가능해요)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF985F35),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: MethodType.values.map((method) {
                          return Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: SelectableChipButton(
                                label: method.label,
                                isSelected: selectedMethod == method,
                                onTap: () => vm.selectMethod(method),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
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
                              builder: (context) => QuickRecordStep2Page(
                                initialDate: widget.initialDate,
                              ),
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
