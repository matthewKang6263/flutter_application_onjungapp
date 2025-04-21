// 📁 lib/pages/calendar_tab/calendar_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/pages/calendar_tab/widgets/year_month_picker_trigger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/components/bottom_sheet/date_picker_bottom_sheet.dart'
    as custom_picker;
import 'package:flutter_application_onjungapp/components/box/exchange_summary_box.dart';
import 'package:flutter_application_onjungapp/components/buttons/rounded_toggle_button.dart';
import 'package:flutter_application_onjungapp/pages/calendar_tab/view/calendar_view.dart';
import 'package:flutter_application_onjungapp/pages/calendar_tab/view/calendar_history_view.dart';
import 'package:flutter_application_onjungapp/viewmodels/auth/user_view_model.dart';
import 'package:flutter_application_onjungapp/viewmodels/calendar_tab/calendar_tab_view_model.dart';

/// 📅 캘린더 탭 메인 페이지
class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  bool _isCalendarView = true; // 달력/내역 토글 상태
  DateTime _selectedMonth = DateTime.now(); // 선택된 연월
  bool _didLoad = false; // 최초 한 번만 로드 플래그

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didLoad) {
      final uid = ref.read(userViewModelProvider).uid;
      if (uid != null) {
        ref
            .read(calendarTabViewModelProvider.notifier)
            .loadRecords(uid, _selectedMonth);
      }
      _didLoad = true;
    }
  }

  /// 🔽 연/월 선택 바텀시트 열기
  Future<void> _pickYearMonth() async {
    final picked = await custom_picker.showDatePickerBottomSheet(
      context: context,
      mode: custom_picker.DatePickerMode.yearMonth,
      initialDate: _selectedMonth,
    );
    if (picked != null) {
      final newMonth = DateTime(picked.year, picked.month);
      setState(() => _selectedMonth = newMonth);

      final uid = ref.read(userViewModelProvider).uid;
      if (uid != null) {
        ref
            .read(calendarTabViewModelProvider.notifier)
            .loadRecords(uid, newMonth);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(calendarTabViewModelProvider);
    final summary =
        ref.read(calendarTabViewModelProvider.notifier).getSummaryForMonth();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── 상단 컨트롤 ─────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  RoundedToggleButton(
                    leftText: '달력',
                    rightText: '내역',
                    isLeftSelected: _isCalendarView,
                    onToggle: (left) => setState(() => _isCalendarView = left),
                  ),
                  const SizedBox(height: 12),
                  YearMonthPickerTrigger(
                    selectedDate: _selectedMonth,
                    onTap: _pickYearMonth,
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

            // ── 본문: 달력 / 내역 ────────────────────
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _isCalendarView
                      ? CalendarView(selectedDate: _selectedMonth)
                      : CalendarHistoryView(selectedDate: _selectedMonth),
            ),
          ],
        ),
      ),
    );
  }
}
