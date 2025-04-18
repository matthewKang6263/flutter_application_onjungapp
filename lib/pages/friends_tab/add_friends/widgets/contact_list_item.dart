import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/dividers/thin_divider.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_application_onjungapp/components/buttons/contact_add_button.dart';

/// 연락처 항목 하나를 렌더링하는 리스트 아이템 위젯
class ContactListItem extends StatelessWidget {
  final Contact contact;
  final bool isAdded;
  final VoidCallback onTapAdd;

  const ContactListItem({
    super.key,
    required this.contact,
    required this.isAdded,
    required this.onTapAdd,
  });

  @override
  Widget build(BuildContext context) {
    final String phone =
        contact.phones.isNotEmpty ? contact.phones.first.number : '번호 없음';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// 🔹 왼쪽: 이름 + 전화번호
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.displayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2A2928),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      phone,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: phone == '번호 없음'
                            ? const Color(0xFFB5B1AA)
                            : const Color(0xFF888580),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              /// 🔹 오른쪽: 추가 버튼
              ContactAddButton(
                isAdded: isAdded,
                onTap: onTapAdd,
                label: isAdded ? '추가됨' : '추가',
              ),
            ],
          ),
        ),

        /// 🔹 항목 구분선
        const ThinDivider(hasMargin: false),
      ],
    );
  }
}
