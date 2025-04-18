// 📁 lib/pages/home_tab/widgets/home_info_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 온정 설명서 / 빠른 기록 안내 카드
class HomeInfoCard extends StatelessWidget {
  final String title; // 제목
  final String subtitle; // 부제목
  final VoidCallback? onTap; // 클릭 시 실행할 함수
  final String? iconPath; // 아이콘 SVG 경로
  final bool iconAfterTitle; // 아이콘 위치 오른쪽 여부

  const HomeInfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.iconPath,
    this.iconAfterTitle = false,
  });

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
            // 🔹 오른쪽 아이콘 카드일 경우 좌측 공간 확보
            if (iconAfterTitle) const SizedBox(width: 64),

            // 🔹 왼쪽 아이콘
            if (!iconAfterTitle)
              iconPath != null
                  ? SvgPicture.asset(iconPath!, width: 48, height: 48)
                  : const SizedBox(width: 48, height: 48),

            if (!iconAfterTitle) const SizedBox(width: 16),

            // 🔹 텍스트 및 우측 아이콘
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
                      ]
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
