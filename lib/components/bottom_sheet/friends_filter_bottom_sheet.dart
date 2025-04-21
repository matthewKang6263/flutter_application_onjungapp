// lib/components/bottom_sheet/friends_filter_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/buttons/selectable_chip_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';

/// 🔹 친구 페이지 필터 바텀시트
/// - 관계(RelationType) + 정렬 옵션
class FriendsFilterBottomSheet extends StatefulWidget {
  final RelationType? selectedRelation; // null이면 전체
  final String selectedSort; // '이름순' or '최신순'

  const FriendsFilterBottomSheet({
    super.key,
    required this.selectedRelation,
    required this.selectedSort,
  });

  @override
  State<FriendsFilterBottomSheet> createState() =>
      _FriendsFilterBottomSheetState();
}

class _FriendsFilterBottomSheetState extends State<FriendsFilterBottomSheet> {
  late RelationType? selectedRelation;
  late String selectedSort;
  final List<String> sortOptions = ['이름순', '최신순'];

  @override
  void initState() {
    super.initState();
    selectedRelation = widget.selectedRelation;
    selectedSort = widget.selectedSort;
  }

  @override
  Widget build(BuildContext context) {
    final double chipWidth = (MediaQuery.of(context).size.width - 32 - 16) / 3;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Color(0x26000000), blurRadius: 20, offset: Offset(0, -5))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('관계',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Pretendard')),
          const SizedBox(height: 8),

          // ● 전체 선택 (null 처리)
          SelectableChipButton(
            label: '전체',
            isSelected: selectedRelation == null,
            onTap: () => setState(() => selectedRelation = null),
          ),
          const SizedBox(height: 8),

          // ● 관계별 필터 (wrap으로 3칩씩)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: RelationType.values.map((relation) {
              return SizedBox(
                width: chipWidth,
                child: SelectableChipButton(
                  label: relation.label,
                  isSelected: selectedRelation == relation,
                  onTap: () => setState(() => selectedRelation = relation),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
          const Text('정렬',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Pretendard')),
          const SizedBox(height: 12),

          // ● 정렬 옵션
          Row(
            children: sortOptions.map((sort) {
              final bool isLast = sort == sortOptions.last;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: isLast ? 0 : 8),
                  child: SelectableChipButton(
                    label: sort,
                    isSelected: selectedSort == sort,
                    onTap: () => setState(() => selectedSort = sort),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
          Center(
            child: BlackFillButton(
              text: '적용',
              onTap: () {
                Navigator.pop(context, {
                  'relation': selectedRelation,
                  'sort': selectedSort,
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
