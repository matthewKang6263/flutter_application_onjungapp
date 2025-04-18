// 📁 lib/services/firebase_auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔹 Firebase Custom Token으로 로그인
  Future<void> signInWithCustomToken(String accessToken) async {
    final uri = Uri.parse(
      'https://issuecustomtoken-ldvo6uzwba-uc.a.run.app',
    );

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'accessToken': accessToken}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final customToken = data['token'];
      await _auth.signInWithCustomToken(customToken);
    } else {
      throw Exception('🔥 Custom token 발급 실패: ${response.body}');
    }
  }
}
