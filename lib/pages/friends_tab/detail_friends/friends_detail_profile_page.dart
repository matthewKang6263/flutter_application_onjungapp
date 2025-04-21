// 📁 lib/pages/friends_tab/detail_friends/friends_detail_profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/viewmodels/friends_tab/profile/friend_profile_view_model.dart';
import 'package:flutter_application_onjungapp/viewmodels/friends_tab/profile/friend_profile_edit_view_model.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/bottom_fixed_button_container.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_fill_button.dart';
import 'package:flutter_application_onjungapp/components/bottom_buttons/widgets/black_outline_button.dart';
import 'package:flutter_application_onjungapp/components/dialogs/confirm_action_dialog.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/detail_friends/view/detail_profile_read_view.dart';
import 'package:flutter_application_onjungapp/pages/friends_tab/detail_friends/view/detail_profile_edit_view.dart';

/// 👤 친구 상세 프로필 페이지
/// - 읽기/편집 모드 전환, 삭제, 저장 처리
class FriendsDetailProfilePage extends ConsumerStatefulWidget {
  final String friendId;

  const FriendsDetailProfilePage({
    super.key,
    required this.friendId,
  });

  @override
  ConsumerState<FriendsDetailProfilePage> createState() =>
      _FriendsDetailProfilePageState();
}

class _FriendsDetailProfilePageState
    extends ConsumerState<FriendsDetailProfilePage> {
  bool isEditMode = false;

  // 컨트롤러/포커스 노드
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _memoController;
  late FocusNode _nameFocus, _phoneFocus, _memoFocus;

  @override
  void initState() {
    super.initState();
    // 프로필 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(friendProfileViewModelProvider.notifier).load(widget.friendId);
    });
    // 컨트롤러 초기화
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _memoController = TextEditingController();
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

  /// 편집 모드 토글
  void _toggleEditMode() {
    final profile = ref.read(friendProfileViewModelProvider);
    if (!isEditMode && profile.friend != null) {
      // 기존 값 로드
      ref
          .read(friendProfileEditViewModelProvider.notifier)
          .load(profile.friend!);
    }
    setState(() => isEditMode = !isEditMode);
  }

  /// 저장 처리
  Future<void> _save() async {
    final profile = ref.read(friendProfileViewModelProvider);
    final editVm = ref.read(friendProfileEditViewModelProvider.notifier);
    final friend = profile.friend!;
    await editVm.save(friend.ownerId, friend.id);
    // 다시 로드
    await ref.read(friendProfileViewModelProvider.notifier).load(friend.id);
    setState(() => isEditMode = false);
  }

  /// 삭제 확인 다이얼로그
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => ConfirmActionDialog(
        title: '친구를 삭제하시겠습니까?',
        cancelText: '취소',
        confirmText: '삭제',
        onCancel: () => Navigator.pop(context),
        onConfirm: () async {
          Navigator.pop(context);
          await ref.read(friendProfileViewModelProvider.notifier).delete();
          if (mounted) Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(friendProfileViewModelProvider);
    final editState = ref.watch(friendProfileEditViewModelProvider);

    // 로드 중 또는 데이터 없음
    if (profileState.isLoading || profileState.friend == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 메인 콘텐츠
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: isEditMode
                    // ── 편집 모드
                    ? FriendsDetailProfileEditView(
                        nameController: _nameController..text = editState.name,
                        phoneController: _phoneController
                          ..text = editState.phone,
                        memoController: _memoController
                          ..text = editState.memo ?? '',
                        nameFocus: _nameFocus,
                        phoneFocus: _phoneFocus,
                        memoFocus: _memoFocus,
                        selectedRelation:
                            editState.relation ?? RelationType.unset,
                        onRelationChanged: (r) => ref
                            .read(friendProfileEditViewModelProvider.notifier)
                            .setRelation(r),
                        onNameClear: () => ref
                            .read(friendProfileEditViewModelProvider.notifier)
                            .setName(''),
                        onPhoneClear: () => ref
                            .read(friendProfileEditViewModelProvider.notifier)
                            .setPhone(''),
                        onMemoClear: () => ref
                            .read(friendProfileEditViewModelProvider.notifier)
                            .setMemo(''),
                      )
                    // ── 읽기 모드
                    : FriendsDetailProfileReadView(
                        name: profileState.friend!.name,
                        phone: profileState.friend!.phone ?? '',
                        relation:
                            profileState.friend!.relation ?? RelationType.unset,
                        memo: profileState.friend!.memo ?? '',
                      ),
              ),
            ),
            // 하단 버튼
            BottomFixedButtonContainer(
              child: isEditMode
                  // 저장 버튼
                  ? BlackFillButton(
                      text: '저장',
                      onTap: _save,
                    )
                  // 삭제 · 편집 토글 버튼
                  : Row(
                      children: [
                        Expanded(
                          child: BlackOutlineButton(
                            text: '삭제',
                            onTap: _confirmDelete,
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
    );
  }
}
