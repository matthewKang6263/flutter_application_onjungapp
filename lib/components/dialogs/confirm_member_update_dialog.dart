// lib/components/dialogs/confirm_member_update_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_outline_button.dart';

/// 🔹 전자장부 인원 변경 확인 다이얼로그
class ConfirmMemberUpdateDialog extends StatelessWidget {
  final int originalCount;
  final int changeCount;
  final bool isExclusion;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

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
    final int updated = isExclusion
        ? (originalCount - changeCount)
        : (originalCount + changeCount);

    Widget infoRow(String label, String value, {bool bold = false}) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
            color: const Color(0xFFF9F4EE),
            borderRadius: BorderRadius.circular(12)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                  fontFamily: 'Pretendard',
                  color: const Color(0xFF985F35))),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                  fontFamily: 'Pretendard',
                  color: const Color(0xFF985F35))),
        ]),
      );
    }

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          shadows: const [
            BoxShadow(
                color: Color(0x26000000), blurRadius: 20, offset: Offset(0, -5))
          ],
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('이대로 수정하나요?',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Pretendard',
                      color: Color(0xFF2A2928))),
              if (isExclusion)
                const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('관련 내역도 함께 지워지니 유의해주세요.',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Pretendard',
                            color: Color(0xFF2A2928)))),
              const SizedBox(height: 24),
              infoRow('기존', '$originalCount명'),
              infoRow(isExclusion ? '제외(-)' : '추가(+)', '$changeCount명'),
              infoRow('변경', '$updated명', bold: true),
              const SizedBox(height: 24),
              Row(children: [
                Expanded(
                    child: BlackOutlineButton(text: '취소', onTap: onCancel)),
                const SizedBox(width: 8),
                Expanded(child: BlackFillButton(text: '확인', onTap: onConfirm)),
              ]),
            ]),
      ),
    );
  }
}
