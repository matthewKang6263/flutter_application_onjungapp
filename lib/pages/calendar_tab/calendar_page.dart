// 📁 lib/pages/calendar_tab/calendar_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/bottom_sheet/date_picker_bottom_sheet.dart'
    as custom_picker;
import 'package:flutter_application_onjungapp/components/box/exchange_summary_box.dart';
import 'package:flutter_application_onjungapp/components/buttons/rounded_toggle_button.dart';
import 'package:flutter_application_onjungapp/pages/calendar_tab/view/calendar_history_view.dart';
import 'package:flutter_application_onjungapp/pages/calendar_tab/view/calendar_view.dart';
import 'package:flutter_application_onjungapp/pages/calendar_tab/widgets/year_month_picker_trigger.dart';
import 'package:flutter_application_onjungapp/viewmodels/calendar_tab/calendar_tab_viewmodel.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  bool isCalendarViewSelected = true;
  DateTime selectedDate = DateTime.now();

  bool _hasLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ 처음 한 번만 데이터 로드
    if (!_hasLoaded) {
      final vm = context.read<CalendarTabViewModel>();
      vm.loadRecords('test-user', selectedDate); // 로그인 연동 전까지는 'test-user' 사용
      _hasLoaded = true;
    }
  }

  Future<void> _showYearMonthPicker() async {
    final result = await custom_picker.showDatePickerBottomSheet(
      context: context,
      mode: custom_picker.DatePickerMode.yearMonth,
      initialDate: selectedDate,
    );

    if (result != null) {
      setState(() {
        selectedDate = DateTime(result.year, result.month);
      });

      // ✅ 선택 월 변경 시 ViewModel 재로드
      final vm = context.read<CalendarTabViewModel>();
      vm.loadRecords('test-user', selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CalendarTabViewModel>();
    final summary = vm.getSummaryForMonth();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  RoundedToggleButton(
                    leftText: '달력',
                    rightText: '내역',
                    isLeftSelected: isCalendarViewSelected,
                    onToggle: (isLeft) {
                      setState(() => isCalendarViewSelected = isLeft);
                    },
                  ),
                  const SizedBox(height: 12),
                  YearMonthPickerTrigger(
                    selectedDate: selectedDate,
                    onTap: _showYearMonthPicker,
                  ),
                  const SizedBox(height: 16),
                  ExchangeSummaryBox(
                    sentCount: summary.sentCount,
                    sentAmount: summary.sentAmount,
                    receivedCount: summary.receivedCount,
                    receivedAmount: summary.receivedAmount,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : isCalendarViewSelected
                      ? CalendarView(selectedDate: selectedDate)
                      : CalendarHistoryView(selectedDate: selectedDate),
            ),
          ],
        ),
      ),
    );
  }
}
