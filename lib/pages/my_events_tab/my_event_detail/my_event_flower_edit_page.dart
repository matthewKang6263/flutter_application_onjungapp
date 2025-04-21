import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_onjungapp/components/app_bar/custom_sub_app_bar.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/text_fields/custom_text_field.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_config.dart';
import 'package:flutter_application_onjungapp/components/text_fields/text_field_type.dart';
import 'package:flutter_application_onjungapp/models/my_event_model.dart';
import 'package:flutter_application_onjungapp/viewmodels/my_events_tab/my_event_detail_view_model.dart';

class MyEventFlowerEditPage extends ConsumerStatefulWidget {
  final MyEvent event;
  const MyEventFlowerEditPage({super.key, required this.event});

  @override
  ConsumerState<MyEventFlowerEditPage> createState() =>
      _MyEventFlowerEditPageState();
}

class _MyEventFlowerEditPageState extends ConsumerState<MyEventFlowerEditPage> {
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    final detailState = ref.read(
      myEventDetailViewModelProvider(widget.event),
    );
    final initialNames = detailState.event?.flowerFriendNames ?? [];

    for (final name in initialNames) {
      _addField(initialText: name);
    }

    if (_controllers.isEmpty) {
      _addField();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _addField({String? initialText}) {
    setState(() {
      final controller = TextEditingController(text: initialText ?? '');
      final focus = FocusNode();
      focus.addListener(() => setState(() {}));
      _controllers.add(controller);
      _focusNodes.add(focus);
    });
  }

  void _removeField(int index) {
    setState(() {
      _controllers[index].dispose();
      _focusNodes[index].dispose();
      _controllers.removeAt(index);
      _focusNodes.removeAt(index);
    });
  }

  void _onComplete() async {
    final vm = ref.read(myEventDetailViewModelProvider(widget.event).notifier);
    final names = _controllers
        .map((c) => c.text.trim())
        .where((name) => name.isNotEmpty)
        .toList();

    vm.updateFlowerNames(names);
    await vm.saveSummary();

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomSubAppBar(title: '화환 수정'),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ...List.generate(_controllers.length, (index) {
                        final controller = _controllers[index];
                        final focus = _focusNodes[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('친구 ${index + 1}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF2A2928),
                                        fontFamily: 'Pretendard',
                                      )),
                                  if (_controllers.length > 1)
                                    GestureDetector(
                                      onTap: () => _removeField(index),
                                      child: const Text('삭제',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFFB5B1AA),
                                            fontFamily: 'Pretendard',
                                          )),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              CustomTextField(
                                config: TextFieldConfig(
                                  controller: controller,
                                  focusNode: focus,
                                  type: TextFieldType.name,
                                  isLarge: true,
                                  maxLength: 10,
                                  onChanged: (_) => setState(() {}),
                                  onClear: () {
                                    controller.clear();
                                    setState(() {});
                                  },
                                ),
                              ),
                              const SizedBox(height: 4),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${controller.text.length}/10자',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFB5B1AA),
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      Center(
                        child: GestureDetector(
                          onTap: _addField,
                          child: SvgPicture.asset(
                            'assets/icons/btn_add_lg.svg',
                            width: 48,
                            height: 48,
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
                child: BlackFillButton(
                  text: '완료',
                  onTap: _onComplete,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
