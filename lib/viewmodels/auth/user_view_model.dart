// 📁 lib/viewmodels/auth/user_view_model.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_application_onjungapp/utils/shared_prefs/prefs_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_onjungapp/models/user_profile_model.dart';
import 'package:flutter_application_onjungapp/repositories/user_repository.dart';
import 'package:flutter_application_onjungapp/services/firebase_auth_service.dart';
import 'package:flutter_application_onjungapp/services/kakao_login_service.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

/// 🔹 사용자 상태 모델
class UserState {
  final String? uid;
  final String? nickname;
  final String? loginMethod;

  const UserState({this.uid, this.nickname, this.loginMethod});

  bool get isLoggedIn => uid != null;

  UserState copyWith({String? uid, String? nickname, String? loginMethod}) {
    return UserState(
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      loginMethod: loginMethod ?? this.loginMethod,
    );
  }

  factory UserState.initial() => const UserState();
}

/// 🔹 사용자 ViewModel
class UserViewModel extends Notifier<UserState> {
  final _userRepo = UserRepository();

  @override
  UserState build() => UserState.initial();

  /// ● 디버그 로그인 (앱 테스트용)
  Future<void> signInAsDebugUser() async {
    final st = state.copyWith(
      uid: 'debug_user_001',
      nickname: '테스트 사용자',
      loginMethod: 'debug',
    );
    state = st;
    // Firestore & SharedPreferences에 저장
    await _userRepo.updateUserProfile(UserProfile(
      uid: st.uid!,
      name: st.nickname!,
      createdAt: DateTime.now(),
    ));
    await PrefsHelper.saveLoginInfo(
        uid: st.uid!, nickname: st.nickname!, loginMethod: st.loginMethod!);
    debugPrint('🐛 디버그 로그인 완료: ${st.uid}');
  }

  /// ● 카카오 로그인 처리
  Future<void> signInWithKakao() async {
    try {
      final kakao = KakaoLoginService();
      final firebase = FirebaseAuthService();

      final token = await kakao.getAccessToken();
      await firebase.signInWithCustomToken(token);

      final user = await kakao.getUserInfo();
      final uid = 'kakao_${user.id}';
      final nickname =
          user.kakaoAccount?.profile?.nickname?.trim() ?? '카카오 사용자';

      state =
          state.copyWith(uid: uid, nickname: nickname, loginMethod: 'kakao');

      // Firestore에 프로필 저장
      await _userRepo.updateUserProfile(UserProfile(
        uid: uid,
        name: nickname,
        createdAt: DateTime.now(),
      ));
      // SharedPreferences에 저장
      await PrefsHelper.saveLoginInfo(
          uid: uid, nickname: nickname, loginMethod: 'kakao');

      debugPrint('✅ 카카오 로그인 성공: $uid');
    } catch (e) {
      debugPrint('❌ 카카오 로그인 실패: $e');
      rethrow;
    }
  }

  /// ● SharedPreferences에서 로그인 정보 복원
  Future<void> restoreUserFromPrefs() async {
    final data = await PrefsHelper.loadLoginInfo();
    if (data?['uid'] != null && data?['nickname'] != null) {
      state = state.copyWith(
          uid: data?['uid'],
          nickname: data?['nickname'],
          loginMethod: data?['loginMethod']);
      debugPrint('🔄 로그인 복원: ${state.uid}');
    } else {
      debugPrint('🔄 복원할 로그인 정보 없음');
    }
  }

  /// ● 로그아웃 처리
  Future<void> signOut() async {
    if (state.loginMethod == 'kakao') {
      try {
        await UserApi.instance.logout();
        debugPrint('🔓 카카오 로그아웃');
      } catch (e) {
        debugPrint('❌ 카카오 로그아웃 실패: $e');
      }
    }
    await PrefsHelper.clearLoginInfo();
    state = UserState.initial();
  }

  /// ● 회원탈퇴 및 데이터 완전 삭제
  Future<void> deleteAccount() async {
    final uid = state.uid;
    if (uid == null) return;
    try {
      // 내 경조사, 기록, 프로필 삭제
      await _userRepo.deleteUserProfile(uid);
      debugPrint('✅ 회원탈퇴 완료: $uid');
    } catch (e) {
      debugPrint('❌ 회원탈퇴 오류: $e');
    }
    await signOut();
  }
}

/// 🔹 전역 Provider
final userViewModelProvider =
    NotifierProvider<UserViewModel, UserState>(UserViewModel.new);
