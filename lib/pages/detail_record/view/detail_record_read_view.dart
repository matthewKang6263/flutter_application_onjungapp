// 📁 lib/pages/record/views/detail_record_read_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_onjungapp/viewmodels/detail_record/detail_record_view_model.dart';
import 'package:flutter_application_onjungapp/components/dividers/thin_divider.dart';

/// 📄 상세 내역 읽기 모드 전용 뷰
class DetailRecordReadView extends StatelessWidget {
  const DetailRecordReadView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DetailRecordViewModel>();

    final List<Map<String, String>> detailItems = [
      {'label': '구분', 'value': viewModel.direction},
      {'label': '경조사', 'value': viewModel.eventType},
      {'label': '날짜', 'value': viewModel.date},
      {'label': '수단', 'value': viewModel.method},
      {'label': '참석 여부', 'value': viewModel.attendance},
      {'label': '메모', 'value': viewModel.memo},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 상단 이름 + 관계 + 금액
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    viewModel.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Pretendard',
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
                      viewModel.relation,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Pretendard',
                        color: Color(0xFFC9747D),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${viewModel.amount}원',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Pretendard',
                  color: Color(0xFF2A2928),
                ),
              ),
            ],
          ),
        ),

        // 🔹 세부 항목 리스트
        ...detailItems.map(
          (item) => Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        item['label']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        item['label'] == '금액'
                            ? '${item['value']}원'
                            : item['value'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Pretendard',
                          color: Color(0xFF2A2928),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const ThinDivider(),
            ],
          ),
        ),
      ],
    );
  }
}
