import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ 이 줄이 반드시 있어야 함!

class PrefsHelper {
  static const String _loginInfoKey = 'loginInfo';

  static Future<void> saveLoginInfo({
    required String uid,
    required String nickname,
    required String loginMethod,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'uid': uid,
      'nickname': nickname.trim().isNotEmpty ? nickname.trim() : '사용자',
      'loginMethod': loginMethod,
    };
    await prefs.setString(_loginInfoKey, jsonEncode(data));
    debugPrint("✅ 로그인 정보 저장 완료");
  }

  static Future<void> clearLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginInfoKey);
  }

  static Future<Map<String, String>> loadLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_loginInfoKey);
    debugPrint("📦 SharedPreferences에서 로드된 값: $jsonString");
    if (jsonString == null) return {};

    try {
      final Map<String, dynamic> decoded = jsonDecode(jsonString);
      return {
        'uid': decoded['uid'] ?? '',
        'nickname': decoded['nickname'] ?? '',
        'loginMethod': decoded['loginMethod'] ?? '',
      };
    } catch (e) {
      return {};
    }
  }
}
