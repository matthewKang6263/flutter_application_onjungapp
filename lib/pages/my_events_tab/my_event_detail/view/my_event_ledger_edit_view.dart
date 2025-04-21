import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_onjungapp/components/dividers/thick_divider.dart';
import 'package:flutter_application_onjungapp/components/dividers/thin_divider.dart';
import 'package:flutter_application_onjungapp/models/enums/attendance_type.dart';
import 'package:flutter_application_onjungapp/models/my_event_model.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_detail/widgets/my_event_ledger_edit_list_item.dart';
import 'package:flutter_application_onjungapp/pages/search/search_ledger_person_page.dart';
import 'package:flutter_application_onjungapp/viewmodels/my_events_tab/my_event_detail_view_model.dart';

class MyEventLedgerEditView extends ConsumerStatefulWidget {
  final MyEvent event;
  final void Function(Set<String>) onSelectionChanged;

  const MyEventLedgerEditView({
    super.key,
    required this.event,
    required this.onSelectionChanged,
  });

  @override
  ConsumerState<MyEventLedgerEditView> createState() =>
      _MyEventLedgerEditViewState();
}

class _MyEventLedgerEditViewState extends ConsumerState<MyEventLedgerEditView> {
  late Set<String> selectedRecordIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final records =
          ref.read(myEventDetailViewModelProvider(widget.event)).records;
      setState(() {
        selectedRecordIds = records.map((r) => r.id).toSet();
      });
      widget.onSelectionChanged(selectedRecordIds);
    });
  }

  void _toggleSelection(String recordId) {
    setState(() {
      if (selectedRecordIds.contains(recordId)) {
        selectedRecordIds.remove(recordId);
      } else {
        selectedRecordIds.add(recordId);
      }
      widget.onSelectionChanged(selectedRecordIds);
    });
  }

  void _toggleAllSelection(List<String> allIds) {
    setState(() {
      if (selectedRecordIds.length == allIds.length) {
        selectedRecordIds.clear();
      } else {
        selectedRecordIds = allIds.toSet();
      }
      widget.onSelectionChanged(selectedRecordIds);
    });
  }

  void _openSearchPage(List<String> allIds) async {
    final updated = await Navigator.push<Set<String>>(
      context,
      MaterialPageRoute(
        builder: (_) => SearchLedgerPersonPage(
          initialSelectedFriendIds: selectedRecordIds,
          excludedIds: {},
          onComplete: (result) => Navigator.pop(context, result),
        ),
      ),
    );

    if (updated != null) {
      setState(() {
        selectedRecordIds = updated;
      });
      widget.onSelectionChanged(selectedRecordIds);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myEventDetailViewModelProvider(widget.event));
    final records = state.records;
    final friends = state.friends;
    final isAllSelected = selectedRecordIds.length == records.length;
    final allRecordIds = records.map((r) => r.id).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 49,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '선택한 친구 (${selectedRecordIds.length}/${records.length}) 명',
                  style: const TextStyle(
                    color: Color(0xFF2A2928),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Pretendard',
                  ),
                ),
                GestureDetector(
                  onTap: () => _openSearchPage(allRecordIds),
                  child: SvgPicture.asset(
                    'assets/icons/search.svg',
                    width: 24,
                    height: 24,
                    color: const Color(0xFFB5B1AA),
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
                          '참석 여부',
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
                          GestureDetector(
                            onTap: () => _toggleAllSelection(allRecordIds),
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
              const ThinDivider(hasMargin: false),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: records.length,
            separatorBuilder: (_, __) => const Divider(
              height: 1,
              color: Color(0xFFE9E5E1),
            ),
            itemBuilder: (_, index) {
              final record = records[index];
              final friend = friends.firstWhere((f) => f.id == record.friendId);
              return MyEventLedgerEditListItem(
                friend: friend,
                isSelected: selectedRecordIds.contains(record.id),
                isAttending: record.attendance == AttendanceType.attended,
                onTap: () => _toggleSelection(record.id),
              );
            },
          ),
        ),
      ],
    );
  }
}
