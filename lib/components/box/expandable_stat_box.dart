import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 통계용 아코디언 바 컴포넌트
/// - 닫힌 상태: 타이틀 + 합계 + 아이콘
/// - 열린 상태: 항목별 리스트 + 아이콘 전환
class ExpandableStatBox extends StatefulWidget {
  final String title; // 예: '받은 마음'
  final String total; // 예: '150,000,000원'
  final Map<String, String> details; // 예: {'현금': '100,000,000원', ...}

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
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 상단 타이틀 영역 (항상 보임)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(color: Color(0xFFF9F4EE)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Color(0xFF2A2928),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  Text(
                    widget.total,
                    style: const TextStyle(
                      color: Color(0xFFC9885C),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ],
              ),
            ),

            // 🔸 열려 있을 경우: 상세 항목 표시
            if (isExpanded)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: const BoxDecoration(color: Color(0xFFE9E5E1)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.details.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key, // 예: '현금'
                            style: const TextStyle(
                              color: Color(0xFF2A2928),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                          Text(
                            entry.value, // 예: '100,000,000원'
                            style: const TextStyle(
                              color: Color(0xFF2A2928),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Pretendard',
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

            // 🔻 하단 접기/펼치기 버튼 영역
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              decoration: const BoxDecoration(color: Color(0xFFE9E5E1)),
              child: Center(
                // ⬅️ 여기만 Row → Center로 교체!
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
