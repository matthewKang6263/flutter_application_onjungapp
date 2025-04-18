import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_application_onjungapp/components/bottom_buttons/bottom_fixed_button_container.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/buttons/contact_add_button.dart';
import 'package:flutter_application_onjungapp/components/custom_snack_bar.dart';
import 'package:flutter_application_onjungapp/components/dividers/thin_divider.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/add_friends/widgets/contact_list_item.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/repositories/friend_repository.dart';

class ContactSyncView extends StatefulWidget {
  const ContactSyncView({super.key});

  @override
  State<ContactSyncView> createState() => _ContactSyncTabState();
}

class _ContactSyncTabState extends State<ContactSyncView> {
  final FriendRepository _friendRepo = FriendRepository();
  final String userId = 'test-user'; // TODO: Replace with actual login UID

  List<Contact> _contacts = [];
  Set<String> _addedContactIds = {};
  DateTime? _lastUpdated;

  Future<void> _syncContacts() async {
    final hasPermission = await FlutterContacts.requestPermission();

    if (hasPermission) {
      final contacts = await FlutterContacts.getContacts(withProperties: true);
      contacts.sort((a, b) => a.displayName.compareTo(b.displayName));

      setState(() {
        _contacts = contacts;
        _addedContactIds.clear();
        _lastUpdated = DateTime.now();
      });
    } else {
      showOnjungSnackBar(context, '주소록 접근 권한이 필요합니다.');
    }
  }

  Future<void> _addAllContacts() async {
    final now = DateTime.now();
    final List<Friend> newFriends = _contacts
        .where((c) => !_addedContactIds.contains(c.id))
        .map((c) => Friend(
              id: const Uuid().v4(),
              name: c.displayName,
              phone: c.phones.isNotEmpty ? c.phones.first.number.trim() : null,
              relation: RelationType.unset,
              memo: '',
              ownerId: userId,
              createdAt: now,
            ))
        .toList();

    for (final friend in newFriends) {
      await _friendRepo.addFriend(friend);
    }

    setState(() {
      _addedContactIds = _contacts.map((c) => c.id).toSet();
    });
  }

  Future<void> _addSingleContact(Contact contact) async {
    final now = DateTime.now();

    final friend = Friend(
      id: const Uuid().v4(),
      name: contact.displayName,
      phone:
          contact.phones.isNotEmpty ? contact.phones.first.number.trim() : null,
      relation: RelationType.unset,
      memo: '',
      ownerId: userId,
      createdAt: now,
    );

    await _friendRepo.addFriend(friend);

    setState(() {
      _addedContactIds.add(contact.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalCount = _contacts.length;
    final addedCount = _addedContactIds.length;
    final allAdded = totalCount > 0 && addedCount == totalCount;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            if (_lastUpdated != null)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                child: Center(
                  child: Text(
                    '마지막 업데이트: ${DateFormat('yyyy년 MM월 dd일 (E)', 'ko').format(_lastUpdated!)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888580),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ),
              ),
            if (_contacts.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '주소록($addedCount/$totalCount)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2A2928),
                        fontFamily: 'Pretendard',
                      ),
                    ),
                    ContactAddButton(
                      isAdded: allAdded,
                      onTap: allAdded ? null : _addAllContacts,
                      label: allAdded ? '전체 추가됨' : '전체 추가',
                    ),
                  ],
                ),
              ),
            if (_contacts.isNotEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: ThinDivider(),
              ),
            Expanded(
              child: _contacts.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          '아직 동기화된 연락처가 존재하지 않아요.\n업데이트 버튼을 눌러 주소록을 동기화해주세요.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF888580),
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: _contacts.length,
                      itemBuilder: (context, index) {
                        final contact = _contacts[index];
                        final isAdded = _addedContactIds.contains(contact.id);
                        return ContactListItem(
                          contact: contact,
                          isAdded: isAdded,
                          onTapAdd: () => _addSingleContact(contact),
                        );
                      },
                    ),
            ),
            BottomFixedButtonContainer(
              child: BlackFillButton(
                text: '업데이트',
                onTap: _syncContacts,
                icon: SvgPicture.asset(
                  'assets/icons/refresh.svg',
                  width: 16,
                  height: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
