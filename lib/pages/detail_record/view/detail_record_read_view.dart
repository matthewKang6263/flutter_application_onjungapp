// 📁 lib/pages/detail_record/view/detail_record_read_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:flutter_application_onjungapp/components/dividers/thin_divider.dart';
import 'package:flutter_application_onjungapp/viewmodels/detail_record/detail_record_view_model.dart';

/// 📄 상세 내역 읽기 전용 뷰
class DetailRecordReadView extends ConsumerWidget {
  final String recordId;
  const DetailRecordReadView({super.key, required this.recordId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.watch(detailRecordViewModelProvider(recordId));

    if (vm.record == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // 출력할 레이블·값 맵 리스트
    final details = <Map<String, String>>[
      {'label': '구분', 'value': vm.direction},
      {'label': '경조사', 'value': vm.eventType},
      {'label': '날짜', 'value': vm.date},
      {'label': '수단', 'value': vm.method},
      {'label': '참석 여부', 'value': vm.attendance},
      {'label': '메모', 'value': vm.memo},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 헤더: 이름·관계·금액 ─────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    vm.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDF3F2),
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: Text(
                      vm.relation,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFC9747D),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                // intl로 천단위 콤마
                '${NumberFormat.decimalPattern('ko').format(vm.record!.amount)}원',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),

        // ── 디테일 리스트 ──────────────────────────
        for (var d in details) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    d['label']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    d['value'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const ThinDivider(),
        ],
      ],
    );
  }
}
