// lib/components/box/expandable_stat_box.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 🔹 통계용 아코디언 박스
/// - 클릭 시 펼치거나 접기
class ExpandableStatBox extends StatefulWidget {
  final String title; // 박스 제목
  final String total; // 총합 텍스트
  final Map<String, String> details; // 세부 항목

  const ExpandableStatBox({
    super.key,
    required this.title,
    required this.total,
    required this.details,
  });

  @override
  State<ExpandableStatBox> createState() => _ExpandableStatBoxState();
}

class _ExpandableStatBoxState extends State<ExpandableStatBox> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => isExpanded = !isExpanded),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 요약
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: const Color(0xFFF9F4EE),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2A2928),
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  Text(
                    widget.total,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFC9885C),
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ],
              ),
            ),

            // 펼쳐질 세부 목록
            if (isExpanded)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                color: const Color(0xFFE9E5E1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.details.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2A2928),
                              fontFamily: 'Pretendard',
                            ),
                          ),
                          Text(
                            entry.value,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF2A2928),
                              fontFamily: 'Pretendard',
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

            // 접기/펼치기 버튼
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              color: const Color(0xFFE9E5E1),
              child: Center(
                child: SvgPicture.asset(
                  isExpanded
                      ? 'assets/icons/navigation_close.svg'
                      : 'assets/icons/navigation_open.svg',
                  width: 16,
                  height: 16,
                  colorFilter:
                      const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
