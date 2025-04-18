// 📁 lib/components/text_fields/text_field_type.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_onjungapp/utils/input_formatters.dart';

/// 🔹 텍스트 필드 타입 정의
/// - 온정에서 사용하는 모든 입력 및 선택형 필드를 enum으로 구분
/// - 입력 가능한 필드(name, phone 등)과 버튼형 선택 필드(event, date 등)를 구분하여 처리
enum TextFieldType {
  name, // 친구 이름 입력
  phone, // 전화번호 입력
  amount, // 금액 입력
  memo, // 메모 입력 (멀티라인)
  search, // 검색어 입력 (입력 가능하지만 주로 검색용 버튼 역할)
  event, // 경조사 종류 선택 (입력 불가능, 버튼형 필드)
  date, // 날짜 선택 (입력 불가능, 버튼형 필드)
  eventTitle, // 경조사 제목 (직접 입력 가능, 내 경조사 탭에서 사용)
}

/// 🔸 TextFieldType 확장 메서드 정의
extension TextFieldTypeExtension on TextFieldType {
  /// UI 라벨 텍스트
  String get label {
    switch (this) {
      case TextFieldType.name:
        return '이름';
      case TextFieldType.phone:
        return '전화번호';
      case TextFieldType.amount:
        return '금액';
      case TextFieldType.memo:
        return '메모';
      case TextFieldType.search:
        return '검색어';
      case TextFieldType.event:
        return '경조사';
      case TextFieldType.date:
        return '날짜';
      case TextFieldType.eventTitle:
        return '경조사 제목';
    }
  }

  /// 힌트 텍스트
  String get hintText {
    switch (this) {
      case TextFieldType.name:
        return '친구 이름을 입력해 주세요';
      case TextFieldType.phone:
        return '전화번호를 입력해 주세요';
      case TextFieldType.amount:
        return '금액을 입력해 주세요';
      case TextFieldType.memo:
        return '메모를 입력해 주세요';
      case TextFieldType.search:
        return '친구 이름을 검색해 주세요';
      case TextFieldType.event:
        return '경조사를 선택해 주세요';
      case TextFieldType.date:
        return '날짜를 선택해 주세요';
      case TextFieldType.eventTitle:
        return '경조사 제목을 입력해 주세요';
    }
  }

  /// 직접 입력 가능한 필드인지 여부
  bool get isInputEnabled {
    return this == TextFieldType.name ||
        this == TextFieldType.phone ||
        this == TextFieldType.amount ||
        this == TextFieldType.memo ||
        this == TextFieldType.search ||
        this == TextFieldType.eventTitle;
  }

  /// 멀티라인 허용 여부
  bool get isMultiline => this == TextFieldType.memo;

  /// 키보드 타입
  TextInputType get keyboardType {
    switch (this) {
      case TextFieldType.amount:
        return TextInputType.number;
      case TextFieldType.phone:
        return TextInputType.phone;
      case TextFieldType.memo:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  /// 입력 포맷터
  List<TextInputFormatter> get inputFormatters {
    switch (this) {
      case TextFieldType.amount:
        return [CurrencyInputFormatter()];
      case TextFieldType.phone:
        return [PhoneNumberInputFormatter()];
      case TextFieldType.memo:
        return [MemoInputFormatter()];
      case TextFieldType.name:
        return [NameInputFormatter()];
      default:
        return []; // 기타 필드는 포맷터 없음
    }
  }
}
