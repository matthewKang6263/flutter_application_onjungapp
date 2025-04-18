import 'package:flutter/material.dart';

/// 공통 확인 다이얼로그
/// [title]은 다이얼로그 제목
/// [cancelText], [onCancel]은 왼쪽 버튼 설정
/// [confirmText], [onConfirm]은 오른쪽 버튼 설정
class ConfirmActionDialog extends StatelessWidget {
  final String title;
  final String cancelText;
  final String confirmText;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const ConfirmActionDialog({
    super.key,
    required this.title,
    required this.cancelText,
    required this.confirmText,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Container(
        width: 358,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔹 다이얼로그 제목
            SizedBox(
              width: 310,
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF2A2928),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Pretendard',
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 🔹 버튼 영역
            Row(
              children: [
                // 🔸 취소 버튼 (Outline)
                Expanded(
                  child: GestureDetector(
                    onTap: onCancel,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        border: Border.all(color: const Color(0xFF2A2928)),
                      ),
                      child: Center(
                        child: Text(
                          cancelText,
                          style: const TextStyle(
                            color: Color(0xFF2A2928),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // 🔸 확인 버튼 (Filled)
                Expanded(
                  child: GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2928),
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      child: Center(
                        child: Text(
                          confirmText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                    ),
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
