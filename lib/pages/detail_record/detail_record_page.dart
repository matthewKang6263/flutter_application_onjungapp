// 📁 lib/pages/record/detail_record_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/bottom_fixed_button_container.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_outline_button.dart';
import 'package:flutter_application_onjungapp/components/dialogs/confirm_action_dialog.dart';
import 'package:flutter_application_onjungapp/pages/detail_record/view/detail_record_edit_view.dart';
import 'package:flutter_application_onjungapp/pages/detail_record/view/detail_record_read_view.dart';
import 'package:flutter_application_onjungapp/viewmodels/detail_record/detail_record_view_model.dart';

/// 📄 상세 내역 페이지 (읽기/편집 토글)
class DetailRecordPage extends ConsumerWidget {
  final String recordId;
  const DetailRecordPage({super.key, required this.recordId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(detailRecordViewModelProvider(recordId));

    // 로딩 또는 오류
    if (vm.record == null) {
      return const Scaffold(
        body: Center(child: Text('내역을 불러올 수 없습니다.')),
      );
    }

    return Scaffold(
      appBar: const CustomSubAppBar(title: '상세 내역'),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: vm.isEditMode
                  ? DetailRecordEditView(recordId: recordId)
                  : DetailRecordReadView(recordId: recordId),
            ),
            BottomFixedButtonContainer(
              child: vm.isEditMode
                  ? BlackFillButton(
                      text: '저장',
                      onTap: vm.save,
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: BlackOutlineButton(
                            text: '삭제',
                            onTap: () => _confirmDelete(context, vm),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: BlackFillButton(
                            text: '편집',
                            onTap: () => vm.setEditMode(true),
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

  void _confirmDelete(BuildContext context, DetailRecordViewModel vm) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => ConfirmActionDialog(
        title: '내역을 삭제하시겠습니까?',
        cancelText: '취소',
        confirmText: '삭제',
        onCancel: () => Navigator.pop(context),
        onConfirm: () async {
          Navigator.pop(context);
          await vm.delete();
          if (context.mounted) Navigator.pop(context);
        },
      ),
    );
  }
}
