// 📁 lib/pages/record/detail_record_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/bottom_fixed_button_container.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_outline_button.dart';
import 'package:flutter_application_onjungapp/components/dialogs/confirm_action_dialog.dart';
import 'package:flutter_application_onjungapp/pages/detail_record/view/detail_record_edit_view.dart';
import 'package:flutter_application_onjungapp/pages/detail_record/view/detail_record_read_view.dart';
import 'package:flutter_application_onjungapp/viewmodels/detail_record/detail_record_view_model.dart';
import 'package:provider/provider.dart';

/// 📄 상세 내역 페이지 (편집/읽기 모드 전환)
class DetailRecordPage extends StatelessWidget {
  final String name;
  final String relation;
  final String amount;
  final String direction;
  final String eventType;
  final String date;
  final String method;
  final String attendance;
  final String memo;

  const DetailRecordPage({
    super.key,
    required this.name,
    required this.relation,
    required this.amount,
    required this.direction,
    required this.eventType,
    required this.date,
    required this.method,
    required this.attendance,
    required this.memo,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailRecordViewModel()
        ..initializeFrom(
          name: name,
          relation: relation,
          amount: amount,
          direction: direction,
          eventType: eventType,
          date: date,
          method: method,
          attendance: attendance,
          memo: memo,
        ),
      child: const _DetailRecordScaffold(),
    );
  }
}

/// 🔹 상세 내역 Scaffold (상태에 따라 읽기/편집 뷰 전환 + 하단 버튼 포함)
class _DetailRecordScaffold extends StatelessWidget {
  const _DetailRecordScaffold();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DetailRecordViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomSubAppBar(title: '상세 내역'),
      body: SafeArea(
        child: Column(
          children: [
            // 🔸 내용 영역 (읽기 또는 편집)
            Expanded(
              child: viewModel.isEditMode
                  ? const DetailRecordEditView()
                  : const DetailRecordReadView(),
            ),

            // 🔸 하단 버튼
            BottomFixedButtonContainer(
              child: viewModel.isEditMode
                  ? BlackFillButton(
                      text: '저장',
                      onTap: viewModel.save,
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: BlackOutlineButton(
                            text: '삭제',
                            onTap: () => _showDeleteDialog(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: BlackFillButton(
                            text: '편집',
                            onTap: () => viewModel.setEditMode(true),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => ConfirmActionDialog(
        title: '내역을 삭제하시겠어요?',
        cancelText: '취소',
        confirmText: '삭제',
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          Navigator.pop(context);
          // TODO: 실제 삭제 로직 추가 필요
        },
      ),
    );
  }
}
