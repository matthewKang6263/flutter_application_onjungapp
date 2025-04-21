import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// 🔹 SharedPreferences 로그인 정보 헬퍼
class PrefsHelper {
  static const _key = 'loginInfo';

  /// ❏ 로그인 정보 저장
  static Future<void> saveLoginInfo({
    required String uid,
    required String nickname,
    required String loginMethod,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final map = {
      'uid': uid,
      'nickname': nickname.isNotEmpty ? nickname : '사용자',
      'method': loginMethod,
    };
    await prefs.setString(_key, jsonEncode(map));
    debugPrint('✅ 로그인 정보 저장 완료');
  }

  /// ❏ 로그인 정보 삭제
  static Future<void> clearLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  /// ❏ 로그인 정보 불러오기
  static Future<Map<String, String>?> loadLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_key);
    if (str == null) return null;
    try {
      final map = jsonDecode(str) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      return null;
    }
  }
}
