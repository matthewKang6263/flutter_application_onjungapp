import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/custom_snack_bar.dart';
import 'package:flutter_application_onjungapp/viewmodels/my_events_tab/my_events_view_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_onjungapp/utils/date_utils.dart';
import 'package:flutter_application_onjungapp/components/buttons/add_friend_button.dart';
import 'package:flutter_application_onjungapp/components/dividers/thin_divider.dart';
import 'package:flutter_application_onjungapp/components/text_fields/custom_text_field.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';
import 'package:flutter_application_onjungapp/pages/my_events_tab/my_event_detail/my_event_flower_edit_page.dart';
import 'package:flutter_application_onjungapp/components/bottom_sheet/date_picker_bottom_sheet.dart'
    as custom_picker;
import 'package:flutter_application_onjungapp/viewmodels/my_events_tab/my_event_detail_view_model.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/repositories/event_record_repository.dart';
import 'package:flutter_application_onjungapp/repositories/my_event_repository.dart';

class MyEventSummaryEditView extends StatefulWidget {
  final String title;
  final DateTime initialDate;
  final String initialEventType;

  const MyEventSummaryEditView({
    super.key,
    required this.title,
    required this.initialDate,
    required this.initialEventType,
  });

  @override
  State<MyEventSummaryEditView> createState() => _MyEventSummaryEditViewState();
}

class _MyEventSummaryEditViewState extends State<MyEventSummaryEditView> {
  late TextEditingController _nameController;
  late FocusNode _nameFocus;
  late TextEditingController _dateController;
  late FocusNode _dateFocus;

  late DateTime _selectedDate;
  late String _selectedEventType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.title);
    _nameFocus = FocusNode();
    _dateFocus = FocusNode();
    _selectedDate = widget.initialDate;
    _selectedEventType = widget.initialEventType;
    _dateController = TextEditingController(text: _formatDate(_selectedDate));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocus.dispose();
    _dateController.dispose();
    _dateFocus.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return formatFullDate(date);
  }

  Widget _buildEventTypeChip(String label) {
    final isSelected = _selectedEventType == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedEventType = label);
          final vm = context.read<MyEventDetailViewModel>();
          vm.updateEventType(
              EventType.values.firstWhere((e) => e.label == label));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFFC9885C) : const Color(0xFFF9F4EE),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'Pretendard',
              color: isSelected ? Colors.white : const Color(0xFF2A2928),
            ),
          ),
        ),
      ),
    );
  }

  void _pickDate() async {
    final picked = await custom_picker.showDatePickerBottomSheet(
      context: context,
      initialDate: _selectedDate,
      mode: custom_picker.DatePickerMode.full,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
      context.read<MyEventDetailViewModel>().updateDate(picked);
    }
    _dateFocus.unfocus();
  }

  Future<void> _onDeletePressed() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('정말 삭제할까요?'),
        content: const Text('해당 경조사와 관련된 모든 내역이 삭제됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final vm = context.read<MyEventDetailViewModel>();
    final eventId = vm.currentEvent.id;
    await MyEventRepository().deleteMyEvent(eventId);
    await EventRecordRepository().deleteByEventId(eventId);

    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      context.read<MyEventsViewModel>().loadMyEvents('test-user');
      showOnjungSnackBar(context, '경조사 삭제가 완료되었습니다');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Row(
                children: [
                  const SizedBox(
                    width: 100,
                    child: Text(
                      '경조사 이름',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2A2928),
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      config: TextFieldConfig(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        type: TextFieldType.eventTitle,
                        isLarge: false,
                        readOnlyOverride: false,
                        maxLength: 10,
                        onChanged: (text) => context
                            .read<MyEventDetailViewModel>()
                            .updateTitle(text),
                        onClear: () {
                          _nameController.clear();
                          context
                              .read<MyEventDetailViewModel>()
                              .updateTitle('');
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const ThinDivider(hasMargin: false),
              const SizedBox(height: 12),
              Row(
                children: [
                  const SizedBox(
                    width: 100,
                    child: Text(
                      '경조사',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2A2928),
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(
                      children: [
                        _buildEventTypeChip('결혼식'),
                        const SizedBox(width: 8),
                        _buildEventTypeChip('돌잔치'),
                        const SizedBox(width: 8),
                        _buildEventTypeChip('장례식'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const SizedBox(width: 112),
                  Expanded(
                    child: Row(
                      children: [
                        _buildEventTypeChip('생일'),
                        const SizedBox(width: 8),
                        _buildEventTypeChip('명절'),
                        const SizedBox(width: 8),
                        _buildEventTypeChip('기타'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const ThinDivider(hasMargin: false),
              const SizedBox(height: 12),
              Row(
                children: [
                  const SizedBox(
                    width: 100,
                    child: Text(
                      '날짜',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2A2928),
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      config: TextFieldConfig(
                        controller: _dateController,
                        focusNode: _dateFocus,
                        type: TextFieldType.date,
                        isLarge: false,
                        readOnlyOverride: true,
                        onTap: _pickDate,
                        onClear: () {
                          _dateController.clear();
                          context
                              .read<MyEventDetailViewModel>()
                              .updateDate(DateTime.now());
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const ThinDivider(hasMargin: false),
              const SizedBox(height: 12),
              Row(
                children: [
                  const SizedBox(
                    width: 100,
                    child: Text(
                      '화환',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2A2928),
                        fontFamily: 'Pretendard',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AddFriendButton(
                      label: '편집',
                      onTap: () {
                        final vm = context.read<MyEventDetailViewModel>();
                        vm.initFlowerControllers();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyEventFlowerEditPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _onDeletePressed,
                  child: const Text('경조사 삭제하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
