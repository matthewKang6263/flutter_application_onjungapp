import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/bottom_fixed_button_container.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/buttons/add_friend_button.dart';
import 'package:flutter_application_onjungapp/models/my_event_model.dart';
import 'package:flutter_application_onjungapp/pages/root_page.dart';
// import 'package:flutter_application_onjungapp/pages/detail_record/detail_record_page.dart'; // 전자장부 페이지로 연결 시 필요

class MyEventAddCompletePage extends StatelessWidget {
  final MyEvent event;

  const MyEventAddCompletePage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        '${event.date.year}년 ${event.date.month}월 ${event.date.day}일';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔹 상단 안내 영역
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔸 날짜 + 경조사명 + 안내 문구
                      Text(
                        '$formattedDate\n${event.title}\n생성되었어요',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2A2928),
                          fontFamily: 'Pretendard',
                          height: 1.36,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 🔸 서브 설명
                      const Text(
                        '전자 장부 페이지에서 정보를 입력해 주세요',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF888580),
                          fontFamily: 'Pretendard',
                        ),
                      ),
                      const SizedBox(height: 32),

                      // 🔸 장부 작성 버튼 (가운데 정렬)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 120),
                        child: AddFriendButton(
                          label: '장부 작성',
                          onTap: () {
                            // TODO: 실제 장부 상세 페이지로 연결
                            // Navigator.push(context, MaterialPageRoute(
                            //   builder: (_) => DetailRecordPage(eventId: event.id),
                            // ));
                            print('➡ 전자 장부로 이동 (eventId: ${event.id})');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 🔹 하단 "완료" 버튼 (내 경조사 탭으로)
            BottomFixedButtonContainer(
              child: BlackFillButton(
                text: '완료',
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RootPage(initialIndex: 3),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
