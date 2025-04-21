// 📁 lib/pages/friends_tab/friends_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/viewmodels/friends_tab/list/friend_list_view_model.dart';
import 'package:flutter_application_onjungapp/viewmodels/friends_tab/history/friend_event_record_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_application_onjungapp/components/buttons/add_friend_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_sheet/friends_filter_bottom_sheet.dart';
import 'package:flutter_application_onjungapp/components/dividers/thick_divider.dart';
import 'package:flutter_application_onjungapp/components/dividers/thin_divider.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/add_friends/add_friends_page.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/detail_friends/friends_detail_history_page.dart';
import 'package:flutter_application_onjungapp/pages/search/search_person_page.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/widgets/friend_list_item.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';
import 'package:flutter_application_onjungapp/viewmodels/auth/user_view_model.dart';

/// 👥 친구 탭 메인 페이지
class FriendsPage extends ConsumerStatefulWidget {
  const FriendsPage({super.key});

  @override
  ConsumerState<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends ConsumerState<FriendsPage> {
  RelationType? _relationFilter;
  String _sortOption = '이름순';

  @override
  void initState() {
    super.initState();
    // 초기 로드: 친구 목록 + 전체 교환 기록
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = ref.read(userViewModelProvider).uid;
      if (uid != null) {
        ref.read(friendListViewModelProvider.notifier).load(uid);
        ref.read(friendEventRecordViewModelProvider.notifier).loadAll(uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(friendListViewModelProvider);
    final evtState = ref.watch(friendEventRecordViewModelProvider);

    // 관계 필터 적용 & 정렬
    var filtered = listState.friends.where((f) {
      if (_relationFilter == null) return true;
      return f.relation == _relationFilter;
    }).toList();
    if (_sortOption == '이름순') {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    } else {
      // 최신순 등 추가 구현 가능
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 상단: 전체 친구 수 + 추가 버튼
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '친구 총 ${filtered.length}명',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2A2928),
                  ),
                ),
                AddFriendButton(
                  label: '+친구 추가',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddFriendsPage()),
                  ),
                ),
              ],
            ),
          ),
          const ThickDivider(),
          // 필터 · 검색
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 관계·정렬 바텀시트
                GestureDetector(
                  onTap: () async {
                    final result =
                        await showModalBottomSheet<Map<String, dynamic>>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => FriendsFilterBottomSheet(
                        selectedRelation: _relationFilter,
                        selectedSort: _sortOption,
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        _relationFilter = result['relation'] as RelationType?;
                        _sortOption = result['sort'] as String;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        '${_relationFilter?.label ?? '전체'} · $_sortOption',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF888580),
                        ),
                      ),
                      const SizedBox(width: 4),
                      SvgPicture.asset('assets/icons/dropdown_arrow.svg',
                          width: 16),
                    ],
                  ),
                ),
                // 검색 아이콘
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SearchPersonPage(
                        onSelectFriend: (friend) {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FriendsDetailHistoryPage(
                                friendId: friend.id,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  child: SvgPicture.asset('assets/icons/search.svg', width: 24),
                ),
              ],
            ),
          ),
          const ThinDivider(),
          // 친구 리스트
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const ThinDivider(hasMargin: false),
              itemBuilder: (_, idx) {
                final f = filtered[idx];
                final related =
                    evtState.records.where((r) => r.friendId == f.id).toList();
                return FriendListItem(
                  friend: f,
                  relatedRecords: related,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FriendsDetailHistoryPage(friendId: f.id),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
