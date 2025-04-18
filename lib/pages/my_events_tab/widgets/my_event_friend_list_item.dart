import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/wrappers/cupertino_touch_wrapper.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/components/tag_label.dart';

/// 📦 경조사 친구 선택 리스트 아이템 위젯
/// - 전체 터치 가능한 아이템 (iOS 스타일 클릭 효과 적용)
/// - 이름 / 관계 태그 / 선택 아이콘 표시
/// - 선택 여부에 따라 체크박스 및 배경 변경 가능
class MyEventFriendListItem extends StatelessWidget {
  final Friend friend; // 🔹 표시할 친구 정보
  final bool isSelected; // 🔹 선택 여부
  final VoidCallback onTap; // 🔹 클릭 시 콜백

  const MyEventFriendListItem({
    super.key,
    required this.friend,
    required this.isSelected,
    required this.onTap,
  });

  /// 🔹 이름이 너무 길면 자르기 (7자 + ..)
  String _formatName(String name) {
    const cutoff = 7;
    if (name.length > cutoff) {
      return '${name.substring(0, cutoff)}..';
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTouchWrapper(
      onTap: onTap,
      child: Container(
        // ✅ 선택 시 배경색 추가 (비선택 시 투명)
        color: isSelected ? const Color(0xFFFAF8F5) : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔸 이름 (좌측 고정 너비)
            SizedBox(
              width: 120,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _formatName(friend.name),
                  style: const TextStyle(
                    color: Color(0xFF2A2928),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Pretendard',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

            // 🔸 관계 태그 (가운데 정렬)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TagLabel.fromRelationType(
                      friend.relation ?? RelationType.unset),
                ],
              ),
            ),

            // 🔸 선택 아이콘 (우측 정렬)
            SizedBox(
              width: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    isSelected
                        ? 'assets/icons/selected.svg'
                        : 'assets/icons/select.svg',
                    width: 24,
                    height: 24,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
