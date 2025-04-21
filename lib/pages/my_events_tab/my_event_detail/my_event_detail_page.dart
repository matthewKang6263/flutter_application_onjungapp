// 📁 lib/pages/my_events_tab/my_event_detail/my_event_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/buttons/rounded_toggle_button.dart';
import 'package:flutter_application_onjungapp/components/dialogs/confirm_member_update_dialog.dart';
import 'package:flutter_application_onjungapp/models/my_event_model.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_detail/view/my_event_ledger_edit_view.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_detail/view/my_event_ledger_read_view.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_detail/view/my_event_summary_edit_view.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_detail/view/my_event_summary_read_view.dart';
import 'package:flutter_application_onjungapp/viewmodels/my_events_tab/my_event_detail_view_model.dart';

class MyEventDetailPage extends ConsumerStatefulWidget {
  final MyEvent event;

  const MyEventDetailPage({super.key, required this.event});

  @override
  ConsumerState<MyEventDetailPage> createState() => _MyEventDetailPageState();
}

class _MyEventDetailPageState extends ConsumerState<MyEventDetailPage> {
  bool isSummarySelected = true;
  bool isSummaryEditing = false;
  bool isLedgerEditing = false;

  Set<String> _latestLedgerSelection = {};

  bool get _currentIsEditing =>
      isSummarySelected ? isSummaryEditing : isLedgerEditing;

  Set<String> _getSelectedLedgerRecordIds() => _latestLedgerSelection;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myEventDetailViewModelProvider(widget.event));
    final notifier =
        ref.read(myEventDetailViewModelProvider(widget.event).notifier);

    final currentEvent = state.event;

    if (state.isLoading || currentEvent == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomSubAppBar(title: currentEvent.title),
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
                        event: currentEvent,
                        title: currentEvent.title,
                        initialDate: currentEvent.date,
                        initialEventType: currentEvent.eventType.label,
                      )
                    : MyEventSummaryReadView(event: currentEvent))
                : (isLedgerEditing
                    ? MyEventLedgerEditView(
                        event: currentEvent,
                        onSelectionChanged: (updated) {
                          setState(() {
                            _latestLedgerSelection = updated;
                          });
                        },
                      )
                    : MyEventLedgerReadView(event: currentEvent)),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 12, 16, 30),
        child: BlackFillButton(
          text: _currentIsEditing ? '완료' : '편집',
          onTap: () => _toggleEditing(state, notifier),
        ),
      ),
    );
  }

  void _toggleEditing(
    MyEventDetailState state,
    MyEventDetailViewModel notifier,
  ) {
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
        final totalCount = state.records.length;
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
              await notifier.saveLedgerChanges(_getSelectedLedgerRecordIds());
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
