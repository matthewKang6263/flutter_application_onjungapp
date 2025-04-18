// 📁 lib/pages/my_events_tab/my_event_detail/my_event_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/buttons/rounded_toggle_button.dart';
import 'package:flutter_application_onjungapp/components/dialogs/confirm_member_update_dialog.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/models/my_event_model.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_detail/view/my_event_ledger_edit_view.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_detail/view/my_event_ledger_read_view.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_detail/view/my_event_summary_edit_view.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_detail/view/my_event_summary_read_view.dart';
import 'package:flutter_application_onjungapp/viewmodels/my_events_tab/my_event_detail_view_model.dart';
import 'package:provider/provider.dart';

/// 📄 내 경조사 상세 페이지 (요약 / 전자 장부 탭 전환)
class MyEventDetailPage extends StatefulWidget {
  final MyEvent event;

  const MyEventDetailPage({super.key, required this.event});

  @override
  State<MyEventDetailPage> createState() => _MyEventDetailPageState();
}

class _MyEventDetailPageState extends State<MyEventDetailPage> {
  bool isSummarySelected = true;
  bool isSummaryEditing = false;
  bool isLedgerEditing = false;

  Set<String> _latestLedgerSelection = {};

  bool get _currentIsEditing =>
      isSummarySelected ? isSummaryEditing : isLedgerEditing;

  Set<String> _getSelectedLedgerRecordIds() => _latestLedgerSelection;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = MyEventDetailViewModel();
        vm.loadData(widget.event);
        return vm;
      },
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomSubAppBar(title: widget.event.title),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RoundedToggleButton(
              leftText: '요약',
              rightText: '전자 장부',
              isLeftSelected: isSummarySelected,
              onToggle: (isLeft) {
                setState(() {
                  isSummarySelected = isLeft;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: isSummarySelected
                ? (isSummaryEditing
                    ? MyEventSummaryEditView(
                        title: widget.event.title,
                        initialDate: widget.event.date,
                        initialEventType: widget.event.eventType.label,
                      )
                    : MyEventSummaryReadView())
                : (isLedgerEditing
                    ? MyEventLedgerEditView(
                        event: widget.event,
                        onSelectionChanged: (updated) {
                          setState(() {
                            _latestLedgerSelection = updated;
                          });
                        },
                      )
                    : MyEventLedgerReadView(event: widget.event)),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 12, 16, 30),
        child: BlackFillButton(
          text: _currentIsEditing ? '완료' : '편집',
          onTap: _toggleEditing,
        ),
      ),
    );
  }

  void _toggleEditing() {
    if (isSummarySelected) {
      setState(() {
        isSummaryEditing = !isSummaryEditing;
      });
    } else {
      if (!isLedgerEditing) {
        setState(() {
          isLedgerEditing = true;
        });
      } else {
        final vm = context.read<MyEventDetailViewModel>();

        final totalCount = vm.records.length;
        final selectedCount = _getSelectedLedgerRecordIds().length;
        final excludedCount = totalCount - selectedCount;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => ConfirmMemberUpdateDialog(
            originalCount: totalCount,
            changeCount: excludedCount,
            isExclusion: true,
            onCancel: () => Navigator.pop(context),
            onConfirm: () async {
              Navigator.pop(context);

              // 🔹 선택된 친구만 유지 → 나머지 삭제
              await vm.saveLedgerChanges(_getSelectedLedgerRecordIds());

              // 🔹 편집 모드 종료
              setState(() {
                isLedgerEditing = false;
              });
            },
          ),
        );
      }
    }
  }
}
