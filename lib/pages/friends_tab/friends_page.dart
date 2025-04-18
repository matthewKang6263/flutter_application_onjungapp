import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/detail_friends/friends_detail_history_page.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/add_friends/add_friends_page.dart';
import 'package:flutter_application_onjungapp/pages/search/search_person_page.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/widgets/friend_list_item.dart';

import 'package:flutter_application_onjungapp/components/buttons/add_friend_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_sheet/friends_filter_bottom_sheet.dart';
import 'package:flutter_application_onjungapp/components/dividers/thick_divider.dart';
import 'package:flutter_application_onjungapp/components/dividers/thin_divider.dart';

import 'package:flutter_application_onjungapp/viewmodels/friends_tab/friend_list_view_model.dart';
import 'package:flutter_application_onjungapp/viewmodels/friends_tab/friend_event_record_view_model.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  RelationType? selectedRelation;
  String selectedSort = '이름순';

  final String userId = 'test-user'; // TODO: Replace with actual login UID

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final listVM = context.read<FriendListViewModel>();
      listVM.loadFriends(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FriendEventRecordViewModel()),
      ],
      child: Consumer<FriendListViewModel>(
        builder: (context, vm, _) {
          final filteredFriends = vm.friends.where((friend) {
            if (selectedRelation == null) return true;
            return friend.relation == selectedRelation;
          }).toList()
            ..sort((a, b) {
              if (selectedSort == '이름순') {
                return a.name.compareTo(b.name);
              }
              return 0;
            });

          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '강민우님의 친구\n총 ${filteredFriends.length}명',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          height: 1.36,
                          color: Color(0xFF2A2928),
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      AddFriendButton(
                        label: '+친구 추가',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AddFriendsPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const ThickDivider(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final result =
                              await showModalBottomSheet<Map<String, dynamic>>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => FriendsFilterBottomSheet(
                              selectedRelation: selectedRelation,
                              selectedSort: selectedSort,
                            ),
                          );
                          if (result != null) {
                            setState(() {
                              selectedRelation =
                                  result['relation'] as RelationType?;
                              selectedSort = result['sort'] ?? '이름순';
                            });
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              '${selectedRelation == null ? "전체" : selectedRelation!.label} · $selectedSort',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF888580),
                                fontFamily: 'Pretendard',
                              ),
                            ),
                            const SizedBox(width: 4),
                            SvgPicture.asset(
                              'assets/icons/dropdown_arrow.svg',
                              width: 16,
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SearchPersonPage(
                                onSelectFriend: (friend) {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FriendsDetailHistoryPage(
                                          friendId: friend.id),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/icons/search.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                const ThinDivider(),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredFriends.length,
                    separatorBuilder: (_, __) =>
                        const ThinDivider(hasMargin: false),
                    itemBuilder: (context, index) {
                      final friend = filteredFriends[index];

                      return FutureBuilder(
                        future: context
                            .read<FriendEventRecordViewModel>()
                            .loadRecordsForFriend(friend.id),
                        builder: (_, snapshot) {
                          final records = context
                              .read<FriendEventRecordViewModel>()
                              .records;
                          final related = records
                              .where((record) => record.friendId == friend.id)
                              .toList();

                          return FriendListItem(
                            friend: friend,
                            relatedRecords: related,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FriendsDetailHistoryPage(
                                      friendId: friend.id),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
