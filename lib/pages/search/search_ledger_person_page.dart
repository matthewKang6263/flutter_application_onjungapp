// 📁 lib/pages/my_events_tab/my_event_detail/search_ledger_person_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/text_fields/custom_text_field.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_detail/widgets/my_event_ledger_edit_list_item.dart';
import 'package:flutter_application_onjungapp/viewmodels/search/search_friend_view_model.dart';
import 'package:flutter_application_onjungapp/viewmodels/auth/user_view_model.dart';

/// 👥 경조사 장부용 친구 검색 & 선택 페이지
class SearchLedgerPersonPage extends ConsumerStatefulWidget {
  final Set<String> initialSelectedFriendIds;
  final void Function(Set<String>)? onComplete;
  final Set<String>? excludedIds;

  const SearchLedgerPersonPage({
    Key? key,
    required this.initialSelectedFriendIds,
    this.onComplete,
    this.excludedIds,
  }) : super(key: key);

  @override
  ConsumerState<SearchLedgerPersonPage> createState() =>
      _SearchLedgerPersonPageState();
}

class _SearchLedgerPersonPageState
    extends ConsumerState<SearchLedgerPersonPage> {
  final _searchCtrl = TextEditingController();
  final _focusNode = FocusNode();
  late Set<String> _selectedIds;
  String _query = '';

  @override
  void initState() {
    super.initState();
    // 초기 선택값 세팅
    _selectedIds = {...widget.initialSelectedFriendIds};

    // 로그인된 userId로 친구 리스트 로드
    final userId = ref.read(userViewModelProvider).uid;
    if (userId != null) {
      ref.read(searchFriendViewModelProvider.notifier).fetchFriends(userId);
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
    final available = state.friends.where((f) => !excluded.contains(f.id));
    final filtered = available
        .where((f) => f.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomSubAppBar(title: '친구 검색'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            const SizedBox(height: 12),
            // 검색 입력 필드
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
            // 친구 리스트
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? const Center(child: Text('검색 결과가 없습니다.'))
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          separatorBuilder: (_, __) =>
                              const Divider(color: Color(0xFFE9E5E1)),
                          itemCount: filtered.length,
                          itemBuilder: (_, i) {
                            final f = filtered[i];
                            final selected = _selectedIds.contains(f.id);
                            return MyEventLedgerEditListItem(
                              friend: f,
                              isSelected: selected,
                              isAttending: true,
                              onTap: () => _toggle(f.id),
                            );
                          },
                        ),
            ),
            // 완료 버튼
            SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 0, 16, 24),
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
