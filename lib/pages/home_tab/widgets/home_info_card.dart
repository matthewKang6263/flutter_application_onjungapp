// 📁 lib/pages/home_tab/widgets/home_info_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 🃏 홈 탭 안내용 정보 카드
/// - [title]: 카드 제목
/// - [subtitle]: 카드 부제목
/// - [onTap]: 카드 클릭 시 콜백 (선택적)
/// - [iconPath]: SVG 아이콘 경로 (선택적)
/// - [iconAfterTitle]: 제목 우측에 아이콘 노출 여부
class HomeInfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final String? iconPath;
  final bool iconAfterTitle;

  const HomeInfoCard({
    Key? key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.iconPath,
    this.iconAfterTitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F4EE),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 아이콘이 제목 뒤에 있을 땐 앞에 자리 확보
            if (iconAfterTitle) const SizedBox(width: 64),

            // 왼쪽 아이콘
            if (!iconAfterTitle)
              iconPath != null
                  ? SvgPicture.asset(iconPath!, width: 48, height: 48)
                  : const SizedBox(width: 48, height: 48),
            if (!iconAfterTitle) const SizedBox(width: 16),

            // 제목·부제목 + (필요 시) 우측 소형 아이콘
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Pretendard',
                          color: Color(0xFF2A2928),
                        ),
                      ),
                      if (iconAfterTitle && iconPath != null) ...[
                        const SizedBox(width: 4),
                        SvgPicture.asset(
                          iconPath!,
                          width: 16,
                          height: 16,
                          color: const Color(0xFFC9885C),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Pretendard',
                      color: Color(0xFF888580),
                    ),
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
