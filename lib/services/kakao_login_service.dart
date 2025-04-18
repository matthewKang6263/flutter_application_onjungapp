// 📁 lib/services/kakao_login_service.dart

import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLoginService {
  /// 🔹 카카오 로그인 후 access token 획득
  Future<String> getAccessToken() async {
    print('👉 Kakao 로그인 시작됨');

    try {
      try {
        final token = await UserApi.instance.loginWithKakaoTalk();
        print('✅ KakaoTalk 로그인 성공');
        return token.accessToken;
      } catch (error) {
        print('⚠️ KakaoTalk 실패 → 계정 로그인 fallback');
        final token = await UserApi.instance.loginWithKakaoAccount();
        return token.accessToken;
      }
    } catch (e) {
      print('❌ Kakao access token 획득 실패: $e');
      rethrow;
    }
  }

  /// 🔹 사용자 정보 조회
  Future<User> getUserInfo() async {
    return await UserApi.instance.me();
  }

  Future<void> logout() async {
    await UserApi.instance.logout();
  }
}
