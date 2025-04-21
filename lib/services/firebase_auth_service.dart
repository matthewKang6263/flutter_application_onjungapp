// 📁 lib/services/firebase_auth_service.dart

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// 🔹 Firebase Custom Token 발급 및 로그인 서비스
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔸 커스텀 토큰 발급을 요청할 엔드포인트
  static const String _customTokenEndpoint =
      'https://issuecustomtoken-ldvo6uzwba-uc.a.run.app';

  /// 🔹 Firebase Custom Token으로 로그인
  /// - [accessToken]: 외부 인증(카카오 등)에서 받은 토큰
  /// - 커스텀 토큰을 받아 Firebase에 로그인 처리
  Future<void> signInWithCustomToken(String accessToken) async {
    final uri = Uri.parse(_customTokenEndpoint);

    debugPrint('🔄 Custom token 요청: $uri');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'accessToken': accessToken}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final customToken = data['token'] as String?;
      if (customToken == null) {
        throw Exception('❌ 응답에 token 필드가 없습니다: ${response.body}');
      }
      debugPrint('✅ Custom token 발급 성공, Firebase 로그인 시도');
      await _auth.signInWithCustomToken(customToken);
      debugPrint('🎉 Firebase 로그인 완료: ${_auth.currentUser?.uid}');
    } else {
      throw Exception(
          '🔥 Custom token 발급 실패: ${response.statusCode} ${response.body}');
    }
  }
}
