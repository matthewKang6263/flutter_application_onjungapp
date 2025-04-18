// 📁 lib/pages/friends_tab/detail_friends/view/friends_detail_profile_read_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/dividers/thin_divider.dart';
import 'package:flutter_application_onjungapp/components/tag_label.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';

/// 📄 친구 상세 프로필 - 읽기 모드 뷰
/// - 이름, 전화번호, 관계, 메모를 단순히 표시만 함
class FriendsDetailProfileReadView extends StatelessWidget {
  final String name;
  final String phone;
  final RelationType relation;
  final String memo;

  const FriendsDetailProfileReadView({
    super.key,
    required this.name,
    required this.phone,
    required this.relation,
    required this.memo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),

        // 🔹 이름
        _buildRowWithDivider(label: '이름', child: _buildStaticText(name)),

        // 🔹 전화번호
        _buildRowWithDivider(label: '전화번호', child: _buildStaticText(phone)),

        // 🔹 관계
        _buildRowWithDivider(
          label: '관계',
          centerLabel: false,
          child: Align(
            alignment: Alignment.centerLeft,
            child: TagLabel.fromRelationType(relation),
          ),
        ),

        // 🔹 메모
        _buildRowWithDivider(
          label: '메모',
          alignTop: true,
          showDivider: false,
          child: _buildMultiLineText(memo),
        ),
      ],
    );
  }

  /// 🔹 공통 행 구성 + 구분선
  Widget _buildRowWithDivider({
    required String label,
    required Widget child,
    bool alignTop = false,
    bool centerLabel = false,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 64),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment:
                alignTop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Pretendard',
                  ),
                  textAlign: centerLabel ? TextAlign.center : TextAlign.start,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: child),
            ],
          ),
        ),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ThinDivider(hasMargin: false),
          ),
      ],
    );
  }

  /// 🔹 단일 텍스트 표시용
  Widget _buildStaticText(String value) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        value,
        style: const TextStyle(
          color: Color(0xFF2A2928),
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Pretendard',
        ),
      ),
    );
  }

  /// 🔹 메모용 멀티라인 텍스트 표시용
  Widget _buildMultiLineText(String value) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        value,
        style: const TextStyle(
          color: Color(0xFF2A2928),
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Pretendard',
        ),
      ),
    );
  }
}
