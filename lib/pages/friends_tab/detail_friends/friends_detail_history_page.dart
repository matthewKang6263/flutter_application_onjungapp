// 📁 lib/pages/friends_tab/detail_friends/friends_detail_history_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/box/exchange_summary_box.dart';
import 'package:flutter_application_onjungapp/components/buttons/rounded_toggle_button.dart';
import 'package:flutter_application_onjungapp/components/dividers/thick_divider.dart';
import 'package:flutter_application_onjungapp/components/dividers/thin_divider.dart';
import 'package:flutter_application_onjungapp/models/enums/attendance_type.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/models/enums/method_type.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';
import 'package:flutter_application_onjungapp/models/event_record_model.dart';
import 'package:flutter_application_onjungapp/pages/detail_record/detail_record_page.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/detail_friends/friends_detail_profile_page.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/detail_friends/widgets/event_record_list_item.dart';
import 'package:flutter_application_onjungapp/pages/quick_record/quick_record_step1.dart';
import 'package:flutter_application_onjungapp/utils/input_formatters.dart';
import 'package:flutter_application_onjungapp/viewmodels/friends_tab/friend_event_record_view_model.dart';
import 'package:flutter_application_onjungapp/viewmodels/friends_tab/friend_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FriendsDetailHistoryPage extends StatefulWidget {
  final String friendId;
  const FriendsDetailHistoryPage({super.key, required this.friendId});

  @override
  State<FriendsDetailHistoryPage> createState() =>
      _FriendsDetailHistoryPageState();
}

class _FriendsDetailHistoryPageState extends State<FriendsDetailHistoryPage> {
  bool isHistorySelected = true;

  @override
  void initState() {
    super.initState();
    const String userId = 'test-user'; // TODO: Replace with actual user ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FriendListViewModel>().loadFriends(userId);
      context
          .read<FriendEventRecordViewModel>()
          .loadRecordsForFriend(widget.friendId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<FriendListViewModel, FriendEventRecordViewModel>(
      builder: (context, friendVm, recordVm, _) {
        final friend =
            friendVm.friends.firstWhereOrNull((f) => f.id == widget.friendId);
        if (friend == null) {
          return const Scaffold(
            body: Center(child: Text('친구 정보를 불러올 수 없습니다.')),
          );
        }

        final records =
            recordVm.records.where((r) => r.friendId == friend.id).toList();
        final sentRecords = records.where((r) => r.isSent).toList();
        final receivedRecords = records.where((r) => !r.isSent).toList();

        final grouped = <String, List<EventRecord>>{};
        for (final record in records) {
          final key = formatDateToKorean(record.date);
          grouped.putIfAbsent(key, () => []).add(record);
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomSubAppBar(title: friend.name),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RoundedToggleButton(
                  leftText: '내역',
                  rightText: '프로필',
                  isLeftSelected: isHistorySelected,
                  onToggle: (isLeft) =>
                      setState(() => isHistorySelected = isLeft),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isHistorySelected
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '현재까지 주고 받은 마음',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2A2928),
                                      fontFamily: 'Pretendard',
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ExchangeSummaryBox(
                                    sentCount: sentRecords.length,
                                    sentAmount: sentRecords.fold(
                                        0, (sum, r) => sum + r.amount),
                                    receivedCount: receivedRecords.length,
                                    receivedAmount: receivedRecords.fold(
                                        0, (sum, r) => sum + r.amount),
                                  ),
                                  const SizedBox(height: 32),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        '상세내역',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF2A2928),
                                          fontFamily: 'Pretendard',
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const QuickRecordStep1Page(),
                                            ),
                                          );
                                        },
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: SvgPicture.asset(
                                            'assets/icons/add.svg',
                                            width: 16,
                                            height: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            const ThickDivider(),
                            Expanded(
                              child: ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                itemCount: grouped.entries.length,
                                itemBuilder: (context, index) {
                                  final entry =
                                      grouped.entries.elementAt(index);
                                  final dateLabel = entry.key;
                                  final recordItems = entry.value;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Text(
                                          dateLabel,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF888580),
                                            fontFamily: 'Pretendard',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const ThinDivider(),
                                      ...recordItems.map(
                                        (record) => Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16, right: 16, top: 10),
                                          child: EventRecordListItem(
                                            record: record,
                                            onTap: () async {
                                              await Future.delayed(
                                                  const Duration(
                                                      milliseconds: 120));
                                              if (!mounted) return;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      DetailRecordPage(
                                                    name: friend.name,
                                                    relation: friend
                                                            .relation?.label ??
                                                        '-',
                                                    amount:
                                                        formatNumberWithComma(
                                                            record.amount),
                                                    direction: record.isSent
                                                        ? '보냄'
                                                        : '받음',
                                                    eventType: record
                                                            .eventType?.label ??
                                                        '-',
                                                    date: formatDateToKorean(
                                                        record.date),
                                                    method:
                                                        record.method?.label ??
                                                            '-',
                                                    attendance: record
                                                            .attendance
                                                            ?.label ??
                                                        '-',
                                                    memo: record.memo ?? '',
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 32),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : FriendsDetailProfilePage(
                          name: friend.name,
                          phone: friend.phone ?? '',
                          relation: friend.relation ?? RelationType.unset,
                          memo: friend.memo ?? '',
                          onSave: (newName, newPhone, newRelation, newMemo) {
                            final friendVm =
                                context.read<FriendListViewModel>();
                            final updated = friend.copyWith(
                              name: newName,
                              phone: newPhone,
                              relation: newRelation,
                              memo: newMemo,
                            );
                            friendVm.updateFriend(updated);
                            setState(() {});
                          },
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
