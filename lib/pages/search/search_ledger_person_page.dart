// 📁 lib/pages/my_events_tab/my_event_detail/search_ledger_person_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/text_fields/custom_text_field.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_detail/widgets/my_event_ledger_edit_list_item.dart';
import 'package:flutter_application_onjungapp/viewmodels/search/search_friend_view_model.dart';
import 'package:flutter_application_onjungapp/viewmodels/auth/user_view_model.dart';

class SearchLedgerPersonPage extends StatefulWidget {
  final Set<String> initialSelectedFriendIds;
  final void Function(Set<String>)? onComplete;
  final Set<String>? excludedIds;

  const SearchLedgerPersonPage({
    super.key,
    required this.initialSelectedFriendIds,
    this.onComplete,
    this.excludedIds,
  });

  @override
  State<SearchLedgerPersonPage> createState() => _SearchLedgerPersonPageState();
}

class _SearchLedgerPersonPageState extends State<SearchLedgerPersonPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late Set<String> _selectedSearchIds;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedSearchIds = Set.from(widget.initialSelectedFriendIds);

    final userId = context.read<UserViewModel>().uid;
    if (userId != null) {
      context.read<SearchFriendViewModel>().fetchFriends(userId);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _toggleSelection(String friendId) {
    setState(() {
      if (_selectedSearchIds.contains(friendId)) {
        _selectedSearchIds.remove(friendId);
      } else {
        _selectedSearchIds.add(friendId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchFriendViewModel>();
    final excludedIds = widget.excludedIds ?? {};

    final availableFriends =
        vm.friends.where((f) => !excludedIds.contains(f.id)).toList();

    final filteredFriends = availableFriends
        .where((f) => f.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomSubAppBar(title: '검색'),
        body: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextField(
                config: TextFieldConfig(
                  controller: _controller,
                  focusNode: _focusNode,
                  type: TextFieldType.search,
                  readOnlyOverride: false,
                  onChanged: _onSearchChanged,
                  onClear: () {
                    _controller.clear();
                    _onSearchChanged('');
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredFriends.isEmpty
                      ? const Center(
                          child: Text(
                            '검색 결과가 없습니다.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFB5B1AA),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredFriends.length,
                          separatorBuilder: (_, __) => Container(
                            height: 1,
                            color: const Color(0xFFE9E5E1),
                          ),
                          itemBuilder: (_, index) {
                            final friend = filteredFriends[index];
                            return MyEventLedgerEditListItem(
                              friend: friend,
                              isSelected:
                                  _selectedSearchIds.contains(friend.id),
                              isAttending: true,
                              onTap: () => _toggleSelection(friend.id),
                            );
                          },
                        ),
            ),
            SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: BlackFillButton(
                text: '완료',
                onTap: () {
                  if (widget.onComplete != null) {
                    widget.onComplete!(_selectedSearchIds);
                  } else {
                    Navigator.pop(context, _selectedSearchIds);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
