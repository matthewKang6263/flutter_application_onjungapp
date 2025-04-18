import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/bottom_fixed_button_container.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_outline_button.dart';
import 'package:flutter_application_onjungapp/components/dialogs/confirm_action_dialog.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/detail_friends/view/detail_profile_edit_view.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/detail_friends/view/detail_profile_read_view.dart';

/// 📄 친구 상세 프로필 메인 페이지 (상세 내역 페이지 구조 참고)
class FriendsDetailProfilePage extends StatefulWidget {
  final String name;
  final String phone;
  final RelationType relation;
  final String memo;

  final void Function(
    String newName,
    String newPhone,
    RelationType newRelation,
    String newMemo,
  )? onSave;

  const FriendsDetailProfilePage({
    super.key,
    required this.name,
    required this.phone,
    required this.relation,
    required this.memo,
    this.onSave,
  });

  @override
  State<FriendsDetailProfilePage> createState() =>
      _FriendsDetailProfilePageState();
}

class _FriendsDetailProfilePageState extends State<FriendsDetailProfilePage> {
  bool isEditMode = false;

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _memoController;

  late FocusNode _nameFocus;
  late FocusNode _phoneFocus;
  late FocusNode _memoFocus;

  late RelationType _selectedRelation;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _phoneController = TextEditingController(text: widget.phone);
    _memoController = TextEditingController(text: widget.memo);
    _selectedRelation = widget.relation;

    _nameFocus = FocusNode();
    _phoneFocus = FocusNode();
    _memoFocus = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _memoController.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _memoFocus.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() => isEditMode = !isEditMode);
  }

  void _handleSave() {
    widget.onSave?.call(
      _nameController.text,
      _phoneController.text,
      _selectedRelation,
      _memoController.text,
    );
    _toggleEditMode();
  }

  void _showDeleteModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => ConfirmActionDialog(
        title: '내역을 삭제하시겠어요?',
        cancelText: '취소',
        confirmText: '삭제',
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          Navigator.pop(context);
          // TODO: 실제 삭제 로직 연결
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // 키보드 내리기
          child: Column(
            children: [
              /// 🔹 읽기 or 편집 뷰
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: isEditMode
                      ? FriendsDetailProfileEditView(
                          nameController: _nameController,
                          phoneController: _phoneController,
                          memoController: _memoController,
                          nameFocus: _nameFocus,
                          phoneFocus: _phoneFocus,
                          memoFocus: _memoFocus,
                          selectedRelation: _selectedRelation,
                          onRelationChanged: (newType) =>
                              setState(() => _selectedRelation = newType),
                          onNameClear: () =>
                              setState(() => _nameController.clear()),
                          onPhoneClear: () =>
                              setState(() => _phoneController.clear()),
                          onMemoClear: () =>
                              setState(() => _memoController.clear()),
                        )
                      : FriendsDetailProfileReadView(
                          name: widget.name,
                          phone: widget.phone,
                          relation: widget.relation,
                          memo: widget.memo,
                        ),
                ),
              ),

              /// 🔹 하단 버튼
              BottomFixedButtonContainer(
                child: isEditMode
                    ? BlackFillButton(
                        text: '저장',
                        onTap: _handleSave,
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: BlackOutlineButton(
                              text: '삭제',
                              onTap: _showDeleteModal,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: BlackFillButton(
                              text: '편집',
                              onTap: _toggleEditMode,
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
