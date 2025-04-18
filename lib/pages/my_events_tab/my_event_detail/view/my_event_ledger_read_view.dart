import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/dividers/thick_divider.dart';
import 'package:flutter_application_onjungapp/models/enums/attendance_type.dart';
import 'package:flutter_application_onjungapp/models/my_event_model.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_detail/my_event_add_friends_page.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_detail/my_event_detail_record_page.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_detail/widgets/my_event_ledger_list_item.dart';
import 'package:flutter_application_onjungapp/components/buttons/add_friend_button.dart';
import 'package:flutter_application_onjungapp/viewmodels/my_events_tab/my_event_detail_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_onjungapp/utils/format_utils.dart'; // ✅ 금액 포맷 적용

class MyEventLedgerReadView extends StatelessWidget {
  final MyEvent event;

  const MyEventLedgerReadView({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MyEventDetailViewModel>();
    final records = vm.records;
    final friends = vm.friends;

    return Column(
      children: [
        // 🔹 상단 상태 문구 + 친구 추가 버튼
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 49,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '마음을 전한 친구 ${records.length}명',
                  style: const TextStyle(
                    color: Color(0xFF2A2928),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Pretendard',
                  ),
                ),
                AddFriendButton(
                  label: '친구 추가',
                  height: 34,
                  width: 90,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MyEventAddFriendsPage(event: event),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        const ThickDivider(),

        // 🔸 리스트 헤더 + Divider
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              SizedBox(
                height: 49,
                child: Row(
                  children: const [
                    SizedBox(
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
                    Expanded(
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
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '금액',
                          style: TextStyle(
                            color: Color(0xFF985F35),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 1, color: const Color(0xFFE9E5E1)),
            ],
          ),
        ),

        // 🔹 친구 목록 리스트
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

              return MyEventLedgerListItem(
                friend: friend,
                isAttending: record.attendance == AttendanceType.attended,
                amount: formatCurrency(record.amount), // ✅ 금액 포맷 적용됨
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyEventDetailRecordPage(
                        records: records,
                        myEvents: [event],
                        friends: friends,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
