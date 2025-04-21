// 📁 lib/services/kakao_login_service.dart

import 'package:flutter/foundation.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

/// 🔹 Kakao 로그인 서비스
class KakaoLoginService {
  /// 🔸 카카오 로그인 후 Access Token 획득
  /// 1) 카카오톡 앱 로그인 시도
  /// 2) 실패 시 카카오 계정 로그인으로 폴백
  Future<String> getAccessToken() async {
    debugPrint('👉 Kakao 로그인 시작');
    try {
      // 1) 앱으로 로그인 시도
      final token = await UserApi.instance.loginWithKakaoTalk();
      debugPrint('✅ KakaoTalk 로그인 성공');
      return token.accessToken;
    } catch (appError) {
      debugPrint('⚠️ KakaoTalk 로그인 실패, 계정 로그인 시도: $appError');
      try {
        // 2) 계정 로그인
        final token = await UserApi.instance.loginWithKakaoAccount();
        debugPrint('✅ KakaoAccount 로그인 성공');
        return token.accessToken;
      } catch (accountError) {
        debugPrint('❌ Kakao 로그인 모두 실패: $accountError');
        rethrow;
      }
    }
  }

  /// 🔹 카카오 사용자 정보 조회
  Future<User> getUserInfo() async {
    debugPrint('🔄 Kakao 사용자 정보 조회');
    return await UserApi.instance.me();
  }

  /// 🔹 카카오 로그아웃
  Future<void> logout() async {
    debugPrint('🔄 Kakao 로그아웃 시도');
    await UserApi.instance.logout();
    debugPrint('🔓 Kakao 로그아웃 완료');
  }
}
