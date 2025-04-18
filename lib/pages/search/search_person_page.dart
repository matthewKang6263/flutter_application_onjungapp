// 📁 lib/pages/search/search_person_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_onjungapp/components/text_fields/custom_text_field.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/widgets/friend_list_item.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/viewmodels/auth/user_view_model.dart';
import 'package:flutter_application_onjungapp/viewmodels/search/search_friend_view_model.dart';

class SearchPersonPage extends StatefulWidget {
  final void Function(Friend)? onSelectFriend;

  const SearchPersonPage({super.key, this.onSelectFriend});

  @override
  State<SearchPersonPage> createState() => _SearchPersonPageState();
}

class _SearchPersonPageState extends State<SearchPersonPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    // 🔹 ViewModel 초기화
    final userId = context.read<UserViewModel>().uid;
    if (userId != null) {
      context.read<SearchFriendViewModel>().fetchFriends(userId);
    }

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchFriendViewModel>();
    final filteredFriends =
        vm.friends.where((f) => f.name.contains(_searchQuery)).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomSubAppBar(title: '검색'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              CustomTextField(
                config: TextFieldConfig(
                  controller: _controller,
                  focusNode: _focusNode,
                  type: TextFieldType.search,
                  readOnlyOverride: false,
                  onTap: () {
                    if (!_focusNode.hasFocus) {
                      FocusScope.of(context).requestFocus(_focusNode);
                    }
                  },
                  onClear: () {
                    _controller.clear();
                    setState(() => _searchQuery = '');
                  },
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
              const SizedBox(height: 24),
              if (_searchQuery.isNotEmpty) ...[
                const Text(
                  '검색 결과',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF888580),
                    fontFamily: 'Pretendard',
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredFriends.isEmpty
                          ? const Center(
                              child: Text(
                                '검색 결과가 없습니다.',
                                style: TextStyle(
                                  color: Color(0xFFB5B1AA),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Pretendard',
                                ),
                              ),
                            )
                          : ListView.separated(
                              itemCount: filteredFriends.length,
                              itemBuilder: (context, index) {
                                final friend = filteredFriends[index];
                                return InkWell(
                                  onTap: () {
                                    if (widget.onSelectFriend != null) {
                                      widget.onSelectFriend!(friend);
                                    } else {
                                      Navigator.pop(context, friend);
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  splashColor: Colors.grey.withOpacity(0.1),
                                  child: FriendListItem(
                                    friend: friend,
                                    relatedRecords: const [], // 검색페이지에서는 비워도 됨
                                  ),
                                );
                              },
                              separatorBuilder: (_, __) =>
                                  const Divider(color: Color(0xFFF0F0F0)),
                            ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
