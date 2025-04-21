// 📁 lib/pages/detail_record/view/detail_record_edit_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_application_onjungapp/components/buttons/money_quick_add_button.dart';
import 'package:flutter_application_onjungapp/components/buttons/selectable_chip_button.dart';
import 'package:flutter_application_onjungapp/components/dividers/thin_divider.dart';
import 'package:flutter_application_onjungapp/components/text_fields/custom_text_field.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';
import 'package:flutter_application_onjungapp/components/bottom_sheet/date_picker_bottom_sheet.dart'
    as custom_picker;
import 'package:flutter_application_onjungapp/viewmodels/detail_record/detail_record_view_model.dart';

/// 📄 상세 내역 편집 모드 뷰
class DetailRecordEditView extends ConsumerWidget {
  final String recordId;
  const DetailRecordEditView({super.key, required this.recordId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(detailRecordViewModelProvider(recordId));

    // 컨텍스트 세팅 (포커스용)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.setContext(context);
    });

    // 데이터 로딩 중
    if (vm.record == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildHeader(vm),
                  const SizedBox(height: 12),
                  _buildAmountField(vm),
                  const SizedBox(height: 12),
                  _buildQuickAddButtons(vm),
                  const ThinDivider(),
                  _buildSection(
                    label: '구분',
                    child:
                        _chipRow(['보냄', '받음'], vm.direction, vm.setDirection),
                  ),
                  const ThinDivider(),
                  _buildSection(
                    label: '경조사',
                    child: _eventTypeChips(vm),
                  ),
                  const ThinDivider(),
                  _buildSection(
                    label: '날짜',
                    child: _datePickerField(context, vm),
                  ),
                  const ThinDivider(),
                  _buildSection(
                    label: '수단',
                    child:
                        _chipRow(['현금', '이체', '선물'], vm.method, vm.setMethod),
                  ),
                  const ThinDivider(),
                  _buildSection(
                    label: '참석 여부',
                    child: _chipRow(
                        ['참석', '미참석'], vm.attendance, vm.setAttendance),
                  ),
                  const ThinDivider(),
                  _buildSection(
                    label: '메모',
                    child: CustomTextField(
                      config: TextFieldConfig(
                        controller: vm.memoController,
                        focusNode: vm.memoFocus,
                        type: TextFieldType.memo,
                        isLarge: false,
                        onChanged: (_) => vm.notify(),
                        onClear: () {
                          vm.memoController.clear();
                          vm.notify();
                        },
                      ),
                    ),
                    centerLabel: true,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 헤더: 이름 + 관계 ─────────────────────────
  Widget _buildHeader(DetailRecordViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            vm.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF3F2),
              borderRadius: BorderRadius.circular(1000),
            ),
            child: Text(
              vm.relation,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFC9747D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 금액 입력 필드 ─────────────────────────
  Widget _buildAmountField(DetailRecordViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomTextField(
        config: TextFieldConfig(
          controller: vm.amountController,
          focusNode: vm.amountFocus,
          type: TextFieldType.amount,
          isLarge: false,
          onChanged: (_) => vm.notify(),
          onClear: () {
            vm.amountController.clear();
            vm.notify();
          },
        ),
      ),
    );
  }

  // ── 빠른 금액 추가 버튼 ────────────────────────
  Widget _buildQuickAddButtons(DetailRecordViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [10000, 50000, 100000, 500000].map((amt) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: amt == 500000 ? 0 : 8),
              child: MoneyQuickAddButton(
                label: '+${amt ~/ 10000}만',
                onTap: () => vm.addAmount(amt),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── 칩 옵션 행 생성 ─────────────────────────
  Widget _chipRow(
    List<String> options,
    String current,
    Function(String) onTap,
  ) {
    return Row(
      children: options.map((opt) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SelectableChipButton(
              label: opt,
              isSelected: current == opt,
              onTap: () => onTap(opt),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── 이벤트 타입 칩 ─────────────────────────
  Widget _eventTypeChips(DetailRecordViewModel vm) {
    const top = ['결혼식', '돌잔치', '장례식'];
    const bottom = ['생일', '명절', '기타'];
    return Column(
      children: [
        _chipRow(top, vm.eventType, vm.setEventType),
        const SizedBox(height: 8),
        _chipRow(bottom, vm.eventType, vm.setEventType),
      ],
    );
  }

  // ── 날짜 선택 필드 ─────────────────────────
  Widget _datePickerField(BuildContext context, DetailRecordViewModel vm) {
    // intl 포맷: yyyy년 M월 d일
    final dateText = vm.dateText.isNotEmpty ? vm.dateText : '날짜를 선택해 주세요';

    return Stack(
      alignment: Alignment.centerRight,
      children: [
        GestureDetector(
          onTap: () async {
            final picked = await custom_picker.showDatePickerBottomSheet(
              context: context,
              mode: custom_picker.DatePickerMode.full,
              initialDate: vm.dateValue,
            );
            if (picked != null) {
              vm.setDate(picked);
              Future.microtask(vm.unfocusAllFields);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE9E5E1)),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Text(
              dateText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: vm.dateText.isNotEmpty
                    ? const Color(0xFF2A2928)
                    : const Color(0xFFB5B1AA),
              ),
            ),
          ),
        ),
        if (vm.dateText.isNotEmpty)
          IconButton(
            icon: SvgPicture.asset('assets/icons/delete.svg'),
            onPressed: vm.clearDate,
          ),
      ],
    );
  }

  // ── 섹션 레이아웃 공통 ───────────────────────
  Widget _buildSection({
    required String label,
    required Widget child,
    bool centerLabel = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment:
            centerLabel ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Pretendard',
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(child: child),
        ],
      ),
    );
  }
}
