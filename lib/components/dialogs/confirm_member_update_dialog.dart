import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_outline_button.dart';

/// 전자장부 인원 변경 시 확인 다이얼로그 컴포넌트
/// ⚠️ 반드시 Dialog 위젯 안에서 사용해야 올바른 위치에 표시됨
class ConfirmMemberUpdateDialog extends StatelessWidget {
  final int originalCount; // 기존 인원 수
  final int changeCount; // 변경된 인원 수 (추가 또는 제외된 수)
  final bool isExclusion; // true면 제외 다이얼로그, false면 추가 다이얼로그
  final VoidCallback onConfirm; // 확인 버튼 콜백
  final VoidCallback onCancel; // 취소 버튼 콜백

  const ConfirmMemberUpdateDialog({
    super.key,
    required this.originalCount,
    required this.changeCount,
    required this.isExclusion,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final int updatedCount = isExclusion
        ? (originalCount - changeCount)
        : (originalCount + changeCount);

    return Dialog(
      // ✅ 다이얼로그로 감싸 중앙 정렬 + 배경 그림자 적용
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: Colors.transparent, // 배경 투명으로 설정
      child: Container(
        width: 358,
        padding: const EdgeInsets.all(24),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          shadows: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            // 🔹 다이얼로그 타이틀
            const Text(
              '이대로 수정하나요?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Pretendard',
                color: Color(0xFF2A2928),
              ),
            ),

            // 🔸 제외 시에만 표시되는 안내 문구
            if (isExclusion)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  '관련 내역도 함께 지워지니 유의해주세요.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Pretendard',
                    color: Color(0xFF2A2928),
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // 🔸 인원 요약 정보 박스
            _InfoBox(label: '기존', value: '$originalCount명'),
            const SizedBox(height: 8),
            _InfoBox(
              label: isExclusion ? '제외(-)' : '추가(+)',
              value: '$changeCount명',
            ),
            const SizedBox(height: 8),
            _InfoBox(
              label: '변경',
              value: '$updatedCount명',
              isBold: true,
            ),

            const SizedBox(height: 24),

            // 🔹 버튼 영역 (취소 / 확인)
            Row(
              children: [
                Expanded(
                  child: BlackOutlineButton(
                    text: '취소',
                    onTap: onCancel,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: BlackFillButton(
                    text: '확인',
                    onTap: onConfirm,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 📦 인원 수 표시용 박스 (라벨 + 값)
class _InfoBox extends StatelessWidget {
  final String label; // 항목 이름 (예: 기존, 제외, 추가 등)
  final String value; // 항목 값 (예: 5명)
  final bool isBold; // 강조 표시 여부

  const _InfoBox({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 16,
      fontFamily: 'Pretendard',
      fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
      color: const Color(0xFF985F35),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: ShapeDecoration(
        color: const Color(0xFFF9F4EE),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle),
          Text(value, style: textStyle, textAlign: TextAlign.right),
        ],
      ),
    );
  }
}
