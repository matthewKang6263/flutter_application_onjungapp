// 📁 파일 경로: lib/pages/my_events_tab/my_event_detail/my_event_add_friends_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/dialogs/confirm_member_update_dialog.dart';
import 'package:flutter_application_onjungapp/models/event_record_model.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/models/my_event_model.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/widgets/my_event_friend_list_item.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/disabled_button.dart';
import 'package:flutter_application_onjungapp/components/dividers/thick_divider.dart';
import 'package:flutter_application_onjungapp/viewmodels/my_events_tab/my_event_detail_view_model.dart';
import 'package:flutter_application_onjungapp/repositories/event_record_repository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';

class MyEventAddFriendsPage extends StatefulWidget {
  final MyEvent event;

  const MyEventAddFriendsPage({super.key, required this.event});

  @override
  State<MyEventAddFriendsPage> createState() => _MyEventAddFriendsPageState();
}

class _MyEventAddFriendsPageState extends State<MyEventAddFriendsPage> {
  final Set<String> _selectedFriendIds = {};
  List<Friend> _availableFriends = [];

  bool get _isNextEnabled => _selectedFriendIds.isNotEmpty;
  bool get _isAllSelected =>
      _selectedFriendIds.length == _availableFriends.length;

  @override
  void initState() {
    super.initState();
    final vm = context.read<MyEventDetailViewModel>();
    final excluded = widget.event.recordIds.toSet();
    _availableFriends =
        vm.friends.where((f) => !excluded.contains(f.id)).toList();
  }

  void _toggleAllSelections() {
    setState(() {
      if (_isAllSelected) {
        _selectedFriendIds.clear();
      } else {
        _selectedFriendIds.addAll(_availableFriends.map((f) => f.id));
      }
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedFriendIds.contains(id)) {
        _selectedFriendIds.remove(id);
      } else {
        _selectedFriendIds.add(id);
      }
    });
  }

  Future<void> _submit() async {
    final vm = context.read<MyEventDetailViewModel>();
    final repo = EventRecordRepository();
    final now = DateTime.now();
    final newRecords = _selectedFriendIds.map((id) {
      return EventRecord(
        id: const Uuid().v4(),
        friendId: id,
        eventId: widget.event.id,
        eventType: widget.event.eventType, // ✅ 필수
        amount: 0,
        date: widget.event.date,
        isSent: false,
        method: null,
        attendance: null,
        memo: null,
        createdBy: widget.event.createdBy,
        createdAt: now,
        updatedAt: now,
      );
    }).toList();

    try {
      for (final record in newRecords) {
        await repo.addEventRecord(record);
      }
      await vm.loadData(widget.event);
    } catch (e) {
      print('🚨 추가 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomSubAppBar(title: '인원 추가'),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 49,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '선택한 친구 (${_selectedFriendIds.length}/${_availableFriends.length}) 명',
                      style: const TextStyle(
                        color: Color(0xFF2A2928),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    SvgPicture.asset('assets/icons/search.svg',
                        width: 24, height: 24, color: Color(0xFFB5B1AA)),
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
                              GestureDetector(
                                onTap: _toggleAllSelections,
                                child: Row(
                                  children: [
                                    Text(
                                      _isAllSelected ? '전체 해제' : '전체 선택',
                                      style: const TextStyle(
                                        color: Color(0xFF985F35),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Pretendard',
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    SvgPicture.asset(
                                      _isAllSelected
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
              child: _availableFriends.isEmpty
                  ? const Center(
                      child: Text(
                        '더이상 추가할 수 있는 친구가 없어요',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFB5B1AA),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _availableFriends.length,
                      separatorBuilder: (_, __) =>
                          Container(height: 1, color: const Color(0xFFE9E5E1)),
                      itemBuilder: (_, index) {
                        final friend = _availableFriends[index];
                        final isSelected =
                            _selectedFriendIds.contains(friend.id);
                        return MyEventFriendListItem(
                          friend: friend,
                          isSelected: isSelected,
                          onTap: () => _toggleSelection(friend.id),
                        );
                      },
                    ),
            ),
            SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: _isNextEnabled
                  ? BlackFillButton(
                      text: '추가하기',
                      onTap: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => Dialog(
                            backgroundColor: Colors.transparent,
                            insetPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: ConfirmMemberUpdateDialog(
                              originalCount: widget.event.recordIds.length,
                              changeCount: _selectedFriendIds.length,
                              isExclusion: false,
                              onConfirm: () async {
                                Navigator.pop(context);
                                await _submit();
                                Navigator.pop(context);
                              },
                              onCancel: () => Navigator.pop(context),
                            ),
                          ),
                        );
                      },
                    )
                  : const DisabledButton(text: '추가하기'),
            ),
          ],
        ),
      ),
    );
  }
}
