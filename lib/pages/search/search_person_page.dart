// 📁 lib/pages/search/search_person_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/text_fields/custom_text_field.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/widgets/friend_list_item.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/viewmodels/search/search_friend_view_model.dart';
import 'package:flutter_application_onjungapp/viewmodels/auth/user_view_model.dart';

/// 👤 친구 검색 & 선택 페이지
class SearchPersonPage extends ConsumerStatefulWidget {
  final void Function(Friend)? onSelectFriend;
  const SearchPersonPage({Key? key, this.onSelectFriend}) : super(key: key);

  @override
  ConsumerState<SearchPersonPage> createState() => _SearchPersonPageState();
}

class _SearchPersonPageState extends ConsumerState<SearchPersonPage> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  String _query = '';

  @override
  void initState() {
    super.initState();
    // 친구 리스트 로드
    final uid = ref.read(userViewModelProvider).uid;
    if (uid != null) {
      ref.read(searchFriendViewModelProvider.notifier).fetchFriends(uid);
    }
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchFriendViewModelProvider);
    final filtered =
        state.friends.where((f) => f.name.contains(_query)).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomSubAppBar(title: '친구 검색'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 12),
              // 검색 입력
              CustomTextField(
                config: TextFieldConfig(
                  controller: _ctrl,
                  focusNode: _focus,
                  type: TextFieldType.search,
                  onTap: () {
                    if (!_focus.hasFocus)
                      FocusScope.of(context).requestFocus(_focus);
                  },
                  onClear: () {
                    _ctrl.clear();
                    setState(() => _query = '');
                  },
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              const SizedBox(height: 24),
              // 결과 헤더
              if (_query.isNotEmpty) ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '검색 결과',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF888580),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              // 리스트
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filtered.isEmpty
                        ? const Center(child: Text('검색 결과가 없습니다.'))
                        : ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => const Divider(
                              color: Color(0xFFF0F0F0),
                            ),
                            itemBuilder: (_, i) {
                              final f = filtered[i];
                              return InkWell(
                                onTap: () {
                                  if (widget.onSelectFriend != null) {
                                    widget.onSelectFriend!(f);
                                  } else {
                                    Navigator.pop(context, f);
                                  }
                                },
                                child: FriendListItem(
                                  friend: f,
                                  relatedRecords: const [],
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
