// 📁 lib/pages/friends_tab/add_friends/view/contact_sync_view.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/add_friends/widgets/contact_list_item.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_application_onjungapp/components/dividers/thin_divider.dart';
import 'package:flutter_application_onjungapp/components/buttons/contact_add_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/bottom_fixed_button_container.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/custom_snack_bar.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/repositories/friend_repository.dart';

/// 📇 연락처 동기화 탭
class ContactSyncView extends StatefulWidget {
  const ContactSyncView({super.key});

  @override
  State<ContactSyncView> createState() => _ContactSyncViewState();
}

class _ContactSyncViewState extends State<ContactSyncView> {
  final _repo = FriendRepository();
  final String userId = 'test-user'; // TODO: 실제 로그인 UID
  List<Contact> _contacts = [];
  final Set<String> _added = {};
  DateTime? _lastUpdated;

  /// 연락처 동기화
  Future<void> _sync() async {
    if (await FlutterContacts.requestPermission()) {
      final list = await FlutterContacts.getContacts(withProperties: true);
      list.sort((a, b) => a.displayName.compareTo(b.displayName));
      setState(() {
        _contacts = list;
        _added.clear();
        _lastUpdated = DateTime.now();
      });
    } else {
      showOnjungSnackBar(context, '주소록 접근 권한이 필요합니다.');
    }
  }

  /// 전체 추가
  Future<void> _addAll() async {
    final now = DateTime.now();
    for (final c in _contacts.where((c) => !_added.contains(c.id))) {
      final f = Friend(
        id: const Uuid().v4(),
        ownerId: userId,
        name: c.displayName,
        phone: c.phones.isNotEmpty ? c.phones.first.number.trim() : null,
        relation: RelationType.unset,
        memo: '',
        createdAt: now,
      );
      await _repo.add(f);
      _added.add(c.id);
    }
    setState(() {});
  }

  /// 단일 추가
  Future<void> _addOne(Contact c) async {
    final now = DateTime.now();
    final f = Friend(
      id: const Uuid().v4(),
      ownerId: userId,
      name: c.displayName,
      phone: c.phones.isNotEmpty ? c.phones.first.number.trim() : null,
      relation: RelationType.unset,
      memo: '',
      createdAt: now,
    );
    await _repo.add(f);
    setState(() => _added.add(c.id));
  }

  @override
  Widget build(BuildContext context) {
    final total = _contacts.length;
    final added = _added.length;
    final allAdded = total > 0 && added == total;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            if (_lastUpdated != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  '마지막 업데이트: ${DateFormat('yyyy-MM-dd (E)', 'ko').format(_lastUpdated!)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF888580),
                  ),
                ),
              ),

            // 주소록 헤더 + 전체 추가 버튼
            if (total > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('주소록 ($added/$total)',
                        style: const TextStyle(fontSize: 16)),
                    ContactAddButton(
                      isAdded: allAdded,
                      label: allAdded ? '전체 추가됨' : '전체 추가',
                      onTap: allAdded ? null : _addAll,
                    ),
                  ],
                ),
              ),
            if (total > 0) const ThinDivider(),

            // 연락처 리스트
            Expanded(
              child: total == 0
                  ? const Center(child: Text('동기화된 연락처가 없습니다.'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: _contacts.length,
                      itemBuilder: (_, i) {
                        final c = _contacts[i];
                        return ContactListItem(
                          contact: c,
                          isAdded: _added.contains(c.id),
                          onTapAdd: () => _addOne(c),
                        );
                      },
                    ),
            ),

            // 업데이트 버튼
            BottomFixedButtonContainer(
              child: BlackFillButton(
                text: '업데이트',
                onTap: _sync,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
