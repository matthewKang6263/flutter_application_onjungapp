import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_onjungapp/utils/date_utils.dart'; // ✅ 포맷 유틸 가져오기

/// 📅 연/월 선택 트리거 컴포넌트
/// - 선택된 연/월 텍스트 + 드롭다운 아이콘
/// - 클릭 시 외부 onTap 콜백 실행
class YearMonthPickerTrigger extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onTap;

  const YearMonthPickerTrigger({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = formatYearMonth(selectedDate); // ✅ 유틸 함수로 대체

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.max, // ✅ 전체 너비 차지하도록
        mainAxisAlignment: MainAxisAlignment.start, // ✅ 왼쪽 정렬
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            formatted,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              fontFamily: 'Pretendard',
              color: Color(0xFF2A2928),
            ),
          ),
          const SizedBox(width: 4),
          SvgPicture.asset(
            'assets/icons/dropdown_arrow.svg',
            width: 16,
            height: 16,
            color: Color(0xFF2A2928),
          ),
        ],
      ),
    );
  }
}
