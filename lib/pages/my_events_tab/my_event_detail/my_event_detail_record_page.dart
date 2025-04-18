// 📁 lib/pages/my_events_tab/my_event_detail/my_event_detail_record_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_outline_button.dart';
import 'package:flutter_application_onjungapp/components/dividers/thin_divider.dart';
import 'package:flutter_application_onjungapp/components/tag_label.dart';
import 'package:flutter_application_onjungapp/components/text_fields/custom_text_field.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';
import 'package:flutter_application_onjungapp/components/buttons/selectable_chip_button.dart';
import 'package:flutter_application_onjungapp/components/buttons/money_quick_add_button.dart';
import 'package:flutter_application_onjungapp/models/enums/attendance_type.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/models/enums/method_type.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';
import 'package:flutter_application_onjungapp/models/event_record_model.dart';
import 'package:flutter_application_onjungapp/models/my_event_model.dart';
import 'package:flutter_application_onjungapp/models/friend_model.dart';
import 'package:flutter_application_onjungapp/repositories/event_record_repository.dart';
import 'package:flutter_application_onjungapp/utils/input_formatters.dart';
import 'package:intl/intl.dart';

class MyEventDetailRecordPage extends StatefulWidget {
  final List<EventRecord> records;
  final List<MyEvent> myEvents;
  final List<Friend> friends;
  final int initialIndex;

  const MyEventDetailRecordPage({
    super.key,
    required this.records,
    required this.myEvents,
    required this.friends,
    required this.initialIndex,
  });

  @override
  State<MyEventDetailRecordPage> createState() =>
      _MyEventDetailRecordPageState();
}

class _MyEventDetailRecordPageState extends State<MyEventDetailRecordPage> {
  late int _currentIndex;
  late EventRecord record;
  late TextEditingController amountController;
  late TextEditingController memoController;
  late TextEditingController dateController;
  late FocusNode amountFocus;
  late FocusNode memoFocus;
  MethodType? selectedMethod;
  AttendanceType? selectedAttendance;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    amountFocus = FocusNode();
    memoFocus = FocusNode();
    _loadRecord();
  }

  void _loadRecord() {
    record = widget.records[_currentIndex];
    selectedMethod = record.method;
    selectedAttendance = record.attendance;
    amountController = TextEditingController(
      text: record.amount > 0 ? formatNumberWithComma(record.amount) : '',
    );
    memoController = TextEditingController(text: record.memo);
    dateController = TextEditingController(
      text: DateFormat('yyyy년 M월 d일 (E)', 'ko').format(record.date),
    );
  }

  Future<void> _saveCurrentRecord() async {
    try {
      final updated = record.copyWith(
        amount: int.tryParse(amountController.text.replaceAll(',', '')) ?? 0,
        memo: memoController.text,
        method: selectedMethod,
        attendance: selectedAttendance,
      );

      widget.records[_currentIndex] = updated;

      // 🔥 Firestore 업데이트
      await EventRecordRepository().updateEventRecord(updated);
    } catch (e) {
      print('🚨 저장 중 오류: $e');
    }
  }

  void _navigatePrevious() async {
    await _saveCurrentRecord(); // 🔄 완료 보장 후 전환
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + widget.records.length) % widget.records.length;
      _loadRecord();
    });
  }

  void _navigateNext() async {
    await _saveCurrentRecord();
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.records.length;
      _loadRecord();
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    memoController.dispose();
    dateController.dispose();
    amountFocus.dispose();
    memoFocus.dispose();
    super.dispose();
  }

  Widget _buildEditSection(String label, Widget child,
      {bool centerLabel = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        crossAxisAlignment:
            centerLabel ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Pretendard',
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _buildButtonRow(
      List<String> options, String selected, Function(String) onSelect,
      {bool isEnabled = true}) {
    return Row(
      children: options.map((opt) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SelectableChipButton(
              label: opt,
              isSelected: selected == opt,
              isEnabled: isEnabled,
              onTap: isEnabled ? () => onSelect(opt) : () {},
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final friend = widget.friends.firstWhere((f) => f.id == record.friendId);
    final event = widget.myEvents.firstWhere((e) => e.id == record.eventId);
    final direction = record.isSent ? '보냄' : '받음';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomSubAppBar(title: '상세 내역 편집'),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  friend.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                                const SizedBox(width: 4),
                                TagLabel.fromRelationType(
                                    friend.relation ?? RelationType.unset),
                              ],
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              config: TextFieldConfig(
                                controller: amountController,
                                focusNode: amountFocus,
                                type: TextFieldType.amount,
                                isLarge: false,
                                onChanged: (_) => setState(() {}),
                                onClear: () {
                                  amountController.clear();
                                  setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                for (final amount in [
                                  10000,
                                  50000,
                                  100000,
                                  500000
                                ])
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: amount == 500000 ? 0 : 8),
                                      child: MoneyQuickAddButton(
                                        label: '+${(amount ~/ 10000)}만',
                                        onTap: () {
                                          final current = int.tryParse(
                                                  amountController.text
                                                      .replaceAll(',', '')) ??
                                              0;
                                          final updated = current + amount;
                                          setState(() {
                                            amountController.text =
                                                formatNumberWithComma(updated);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildEditSection(
                        '구분',
                        _buildButtonRow(['보냄', '받음'], direction, (_) {},
                            isEnabled: false),
                        centerLabel: true,
                      ),
                      const SizedBox(height: 6),
                      const ThinDivider(),
                      const SizedBox(height: 6),
                      _buildEditSection(
                        '경조사',
                        Column(
                          children: [
                            _buildButtonRow([
                              '결혼식',
                              '돌잔치',
                              '장례식'
                            ], event.eventType.label, (_) {}, isEnabled: false),
                            const SizedBox(height: 8),
                            _buildButtonRow([
                              '생일',
                              '명절',
                              '기타'
                            ], event.eventType.label, (_) {}, isEnabled: false),
                          ],
                        ),
                        centerLabel: true,
                      ),
                      const SizedBox(height: 6),
                      const ThinDivider(),
                      const SizedBox(height: 6),
                      _buildEditSection(
                        '날짜',
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE9E5E1)),
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xFFF7F6F5),
                          ),
                          child: Text(
                            dateController.text,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFB5B1AA),
                            ),
                          ),
                        ),
                        centerLabel: true,
                      ),
                      const SizedBox(height: 6),
                      const ThinDivider(),
                      const SizedBox(height: 6),
                      _buildEditSection(
                        '수단',
                        _buildButtonRow(
                          MethodType.values.map((e) => e.label).toList(),
                          selectedMethod?.label ?? '',
                          (selected) {
                            setState(() {
                              selectedMethod = MethodType.values
                                  .firstWhere((e) => e.label == selected);
                            });
                          },
                        ),
                        centerLabel: true,
                      ),
                      const SizedBox(height: 6),
                      const ThinDivider(),
                      const SizedBox(height: 6),
                      _buildEditSection(
                        '참석 여부',
                        _buildButtonRow(
                          AttendanceType.values.map((e) => e.label).toList(),
                          selectedAttendance?.label ?? '',
                          (selected) {
                            setState(() {
                              selectedAttendance = selected == '참석'
                                  ? AttendanceType.attended
                                  : AttendanceType.notAttended;
                            });
                          },
                        ),
                        centerLabel: true,
                      ),
                      const SizedBox(height: 6),
                      const ThinDivider(),
                      const SizedBox(height: 6),
                      _buildEditSection(
                        '메모',
                        CustomTextField(
                          config: TextFieldConfig(
                            controller: memoController,
                            focusNode: memoFocus,
                            type: TextFieldType.memo,
                            isLarge: false,
                            onChanged: (_) => setState(() {}),
                            onClear: () {
                              memoController.clear();
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              SafeArea(
                minimum: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: BlackOutlineButton(
                        text: '이전',
                        onTap: _navigatePrevious,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: BlackFillButton(
                        text: '다음',
                        onTap: _navigateNext,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
