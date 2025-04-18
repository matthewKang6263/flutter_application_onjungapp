// 📁 lib/pages/record/views/detail_record_edit_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:flutter_application_onjungapp/components/buttons/money_quick_add_button.dart';
import 'package:flutter_application_onjungapp/components/buttons/selectable_chip_button.dart';
import 'package:flutter_application_onjungapp/components/dividers/thin_divider.dart';
import 'package:flutter_application_onjungapp/components/text_fields/custom_text_field.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';
import 'package:flutter_application_onjungapp/components/bottom_sheet/date_picker_bottom_sheet.dart'
    as custom;
import 'package:flutter_application_onjungapp/viewmodels/detail_record/detail_record_view_model.dart';

/// 📄 상세 내역 편집 모드 뷰 (포커스 복귀 방지까지 포함한 최종 버전)
class DetailRecordEditView extends StatefulWidget {
  const DetailRecordEditView({super.key});

  @override
  State<DetailRecordEditView> createState() => _DetailRecordEditViewState();
}

class _DetailRecordEditViewState extends State<DetailRecordEditView> {
  @override
  void initState() {
    super.initState();
    // ✅ context는 initState에서 직접 사용 불가하므로 다음 프레임에서 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<DetailRecordViewModel>();
      viewModel.setContext(context); // context 저장 (포커스 해제용)
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DetailRecordViewModel>();

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

                  /// 🔸 이름 + 관계 + 금액 필드
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              viewModel.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFDF3F2),
                                borderRadius: BorderRadius.circular(1000),
                              ),
                              child: Text(
                                viewModel.relation,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Pretendard',
                                  color: Color(0xFFC9747D),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          config: TextFieldConfig(
                            controller: viewModel.amountController,
                            focusNode: viewModel.amountFocus,
                            type: TextFieldType.amount,
                            isLarge: false,
                            onChanged: (_) => viewModel.notify(),
                            onClear: () {
                              viewModel.amountController.clear();
                              viewModel.notify();
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            for (final amount in [10000, 50000, 100000, 500000])
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: amount == 500000 ? 0 : 8),
                                  child: MoneyQuickAddButton(
                                    label: '+${amount ~/ 10000}만',
                                    onTap: () => viewModel.addAmount(amount),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 🔸 구분
                  _buildEditSection(
                    label: '구분',
                    child: _buildChipRow(['보냄', '받음'], viewModel.direction,
                        viewModel.setDirection),
                    centerLabel: true,
                  ),
                  const ThinDivider(),

                  /// 🔸 경조사
                  _buildEditSection(
                    label: '경조사',
                    child: Column(
                      children: [
                        _buildChipRow(['결혼식', '돌잔치', '장례식'],
                            viewModel.eventType, viewModel.setEventType),
                        const SizedBox(height: 8),
                        _buildChipRow(['생일', '명절', '기타'], viewModel.eventType,
                            viewModel.setEventType),
                      ],
                    ),
                    centerLabel: true,
                  ),
                  const ThinDivider(),

                  /// 🔸 날짜
                  _buildEditSection(
                    label: '날짜',
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final selected =
                                await custom.showDatePickerBottomSheet(
                              context: context,
                              mode: custom.DatePickerMode.full,
                            );
                            if (selected != null) {
                              // ✅ 포커스가 자동으로 돌아오는 걸 방지하기 위해 다음 프레임에서 unfocus 처리
                              Future.delayed(Duration.zero, () {
                                viewModel.unfocusAllFields();
                              });
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFFE9E5E1)),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: Text(
                              viewModel.dateText.isNotEmpty
                                  ? viewModel.dateText
                                  : '날짜를 선택해 주세요',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Pretendard',
                                color: viewModel.dateText.isNotEmpty
                                    ? const Color(0xFF2A2928)
                                    : const Color(0xFFB5B1AA),
                              ),
                            ),
                          ),
                        ),
                        if (viewModel.dateText.isNotEmpty)
                          IconButton(
                            icon: SvgPicture.asset('assets/icons/delete.svg'),
                            onPressed: () => viewModel.clearDate(),
                          ),
                      ],
                    ),
                    centerLabel: true,
                  ),
                  const ThinDivider(),

                  /// 🔸 수단
                  _buildEditSection(
                    label: '수단',
                    child: _buildChipRow(['현금', '이체', '선물'], viewModel.method,
                        viewModel.setMethod),
                    centerLabel: true,
                  ),
                  const ThinDivider(),

                  /// 🔸 참석 여부
                  _buildEditSection(
                    label: '참석 여부',
                    child: _buildChipRow(['참석', '미참석'], viewModel.attendance,
                        viewModel.setAttendance),
                    centerLabel: true,
                  ),
                  const ThinDivider(),

                  /// 🔸 메모
                  _buildEditSection(
                    label: '메모',
                    child: CustomTextField(
                      config: TextFieldConfig(
                        controller: viewModel.memoController,
                        focusNode: viewModel.memoFocus,
                        type: TextFieldType.memo,
                        isLarge: false,
                        onChanged: (_) => viewModel.notify(),
                        onClear: () {
                          viewModel.memoController.clear();
                          viewModel.notify();
                        },
                      ),
                    ),
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

  /// 🔹 라벨 + 필드 한 줄 묶음
  Widget _buildEditSection({
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

  /// 🔹 칩 버튼 묶음
  Widget _buildChipRow(
    List<String> options,
    String selected,
    Function(String) onTap,
  ) {
    return Row(
      children: options.map((option) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SelectableChipButton(
              label: option,
              isSelected: selected == option,
              onTap: () => onTap(option),
            ),
          ),
        );
      }).toList(),
    );
  }
}
