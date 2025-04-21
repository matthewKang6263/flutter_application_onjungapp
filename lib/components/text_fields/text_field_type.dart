// lib/components/text_fields/text_field_type.dart

import 'package:flutter/services.dart';
import 'package:flutter_application_onjungapp/utils/%08formatters/currency_formatter.dart';
import 'package:flutter_application_onjungapp/utils/%08formatters/memo_formatter.dart';
import 'package:flutter_application_onjungapp/utils/%08formatters/name_formatter.dart';
import 'package:flutter_application_onjungapp/utils/%08formatters/phone_formatter.dart';

/// 🔹 입력 필드 타입 정의
enum TextFieldType {
  name, // 이름 입력
  phone, // 전화번호 입력
  amount, // 금액 입력
  memo, // 메모 입력
  search, // 검색어 입력
  event, // 경조사 선택 (버튼형)
  date, // 날짜 선택 (버튼형)
  eventTitle, // 내 경조사 제목 입력
}

/// 🔸 TextFieldType 확장 메서드
extension TextFieldTypeExtension on TextFieldType {
  /// ● UI 표시용 라벨 텍스트
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

  /// ● 힌트 텍스트
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

  /// ● 직접 입력 가능 여부
  bool get isInputEnabled {
    switch (this) {
      case TextFieldType.event:
      case TextFieldType.date:
        return false;
      default:
        return true;
    }
  }

  /// ● 멀티라인 허용 여부
  bool get isMultiline => this == TextFieldType.memo;

  /// ● 적합한 키보드 타입
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

  /// ● 입력 포맷터 리스트
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
        return [];
    }
  }
}
