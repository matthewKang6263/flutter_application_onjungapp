// 📁 lib/pages/search/search_event_person_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/text_fields/custom_text_field.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/widgets/my_event_friend_list_item.dart';
import 'package:flutter_application_onjungapp/viewmodels/search/search_friend_view_model.dart';
import 'package:flutter_application_onjungapp/viewmodels/auth/user_view_model.dart';

/// 👥 경조사 인원 검색 & 선택 페이지
class SearchEventPersonPage extends ConsumerStatefulWidget {
  final Set<String> initialSelectedFriendIds;
  final void Function(Set<String>)? onComplete;
  final Set<String>? excludedIds;

  const SearchEventPersonPage({
    super.key,
    required this.initialSelectedFriendIds,
    this.onComplete,
    this.excludedIds,
  });

  @override
  ConsumerState<SearchEventPersonPage> createState() =>
      _SearchEventPersonPageState();
}

class _SearchEventPersonPageState extends ConsumerState<SearchEventPersonPage> {
  final _searchCtrl = TextEditingController();
  final _focusNode = FocusNode();

  late Set<String> _selectedIds;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selectedIds = {...widget.initialSelectedFriendIds};

    final uid = ref.read(userViewModelProvider).uid;
    if (uid != null) {
      ref.read(searchFriendViewModelProvider.notifier).fetchFriends(uid);
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch(String q) => setState(() => _query = q);

  void _toggle(String id) {
    setState(() {
      if (_selectedIds.contains(id))
        _selectedIds.remove(id);
      else
        _selectedIds.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchFriendViewModelProvider);
    final excluded = widget.excludedIds ?? {};

    final available =
        state.friends.where((f) => !excluded.contains(f.id)).toList();
    final filtered = available.where((f) {
      return f.name.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: const CustomSubAppBar(title: '인원 검색'),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextField(
                config: TextFieldConfig(
                  controller: _searchCtrl,
                  focusNode: _focusNode,
                  type: TextFieldType.search,
                  readOnlyOverride: false,
                  onChanged: _onSearch,
                  onClear: () {
                    _searchCtrl.clear();
                    _onSearch('');
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? const Center(
                          child: Text('검색 결과가 없습니다.'),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              const Divider(color: Color(0xFFE9E5E1)),
                          itemBuilder: (ctx, i) {
                            final friend = filtered[i];
                            final selected = _selectedIds.contains(friend.id);
                            return MyEventFriendListItem(
                              friend: friend,
                              isSelected: selected,
                              onTap: () => _toggle(friend.id),
                            );
                          },
                        ),
            ),
            SafeArea(
              minimum: const EdgeInsets.all(16),
              child: BlackFillButton(
                text: '완료',
                onTap: () {
                  if (widget.onComplete != null) {
                    widget.onComplete!(_selectedIds);
                  } else {
                    Navigator.pop(context, _selectedIds);
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
