import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_application_onjungapp/utils/prefs_helper.dart';
import 'package:flutter_application_onjungapp/services/kakao_login_service.dart';
import 'package:flutter_application_onjungapp/services/firebase_auth_service.dart';

class UserViewModel extends ChangeNotifier {
  String? uid;
  String? nickname;
  String? loginMethod;

  bool get isLoggedIn => uid != null;

  /// 🔹 디버그 로그인 (실기기 없어도 테스트용)
  Future<void> signInAsDebugUser() async {
    uid = 'debug_user_001';
    nickname = '테스트 사용자';
    loginMethod = 'debug';

    await _saveUserToFirestore();
    await PrefsHelper.saveLoginInfo(
      uid: uid!,
      nickname: nickname!,
      loginMethod: loginMethod!,
    );

    debugPrint('🐛 디버그 로그인 완료: $uid / $nickname');
    notifyListeners();
  }

  /// 🔹 카카오 로그인
  Future<void> signInWithKakao() async {
    try {
      final kakao = KakaoLoginService();
      final firebase = FirebaseAuthService();

      final accessToken = await kakao.getAccessToken();
      await firebase.signInWithCustomToken(accessToken);

      final user = await kakao.getUserInfo();
      uid = 'kakao_${user.id}';
      nickname = user.kakaoAccount?.profile?.nickname?.trim() ?? '카카오 사용자';
      loginMethod = 'kakao';

      await _saveUserToFirestore();
      await PrefsHelper.saveLoginInfo(
        uid: uid!,
        nickname: nickname!,
        loginMethod: loginMethod!,
      );

      debugPrint('✅ 카카오 로그인 성공: $uid / $nickname');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ [카카오 로그인 실패] $e');
      rethrow;
    }
    debugPrint("✅ 로그인 성공 후 상태: uid=$uid, nickname=$nickname, method=$loginMethod");
  }

  // /// 🔹 애플 로그인 (사용 시 주석 해제)
  // Future<void> signInWithApple() async {
  //   try {
  //     final credential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );

  //     uid = 'apple_${credential.userIdentifier}';
  //     nickname = credential.givenName?.trim() ?? 'Apple 사용자';
  //     loginMethod = 'apple';

  //     await _saveUserToFirestore();
  //     await PrefsHelper.saveLoginInfo(
  //       uid: uid!,
  //       nickname: nickname!,
  //       loginMethod: loginMethod!,
  //     );

  //     debugPrint('✅ 애플 로그인 성공: $uid / $nickname');
  //     notifyListeners();
  //   } catch (e) {
  //     debugPrint('❌ [애플 로그인 실패] $e');
  //     rethrow;
  //   }
  // }

  /// 🔸 로그인 정보 복원 (SplashPage에서 사용)
  Future<void> restoreUserFromPrefs() async {
    final data = await PrefsHelper.loadLoginInfo();
    uid = data['uid'];
    nickname = data['nickname'];
    loginMethod = data['loginMethod'];

    if (uid != null) {
      debugPrint('🔄 로그인 복원됨: $uid / $nickname');
      notifyListeners();
    } else {
      debugPrint('🔄 로그인 복원 실패: 저장된 정보 없음');
    }
  }

  /// 🔸 Firestore에 사용자 정보 저장
  Future<void> _saveUserToFirestore() async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    await docRef.set({
      'nickname': nickname,
      'loginMethod': loginMethod,
      'signedInAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// 🔸 로그아웃
  Future<void> signOut() async {
    if (loginMethod == 'kakao') {
      try {
        await UserApi.instance.logout();
        debugPrint('🔓 카카오 로그아웃 완료');
      } catch (e) {
        debugPrint('❌ [카카오 로그아웃 실패] $e');
      }
    }

    await PrefsHelper.clearLoginInfo();

    uid = null;
    nickname = null;
    loginMethod = null;
    notifyListeners();
  }

  /// 🔸 회원탈퇴
  Future<void> deleteAccount() async {
    if (uid == null) return;
    final firestore = FirebaseFirestore.instance;

    try {
      final myEvents = await firestore
          .collection('myEvents')
          .where('userId', isEqualTo: uid)
          .get();
      for (final doc in myEvents.docs) {
        await firestore.collection('myEvents').doc(doc.id).delete();
      }

      final eventRecords = await firestore
          .collection('eventRecords')
          .where('userId', isEqualTo: uid)
          .get();
      for (final doc in eventRecords.docs) {
        await firestore.collection('eventRecords').doc(doc.id).delete();
      }

      await firestore.collection('users').doc(uid).delete();

      debugPrint('✅ 탈퇴 성공: 연관 데이터 전부 삭제됨');
    } catch (e) {
      debugPrint('❌ [회원탈퇴 오류] $e');
    }

    await signOut();
  }
}