// lib/models/event_record_model.dart

import 'package:flutter_application_onjungapp/models/enums/event_type.dart';
import 'package:flutter_application_onjungapp/models/enums/method_type.dart';
import 'package:flutter_application_onjungapp/models/enums/attendance_type.dart';

/// 🔹 단일 경조사 상세내역 모델
/// - 친구별 주고받은 금액, 날짜, 수단, 참석 여부, 메모 등을 관리
class EventRecord {
  final String id;
  final String friendId;
  final String eventId;
  final EventType? eventType; // 이벤트 종류 (받음/보냄 구분에 참고)
  final int amount; // 금액
  final DateTime date; // 발생일
  final bool isSent; // 보낸지(true)/받은지(false) 구분
  final MethodType? method; // 수단
  final AttendanceType? attendance; // 참석 여부
  final String? memo; // 메모
  final String createdBy; // 생성 사용자
  final DateTime createdAt;
  final DateTime updatedAt;

  EventRecord({
    required this.id,
    required this.friendId,
    required this.eventId,
    required this.eventType,
    required this.amount,
    required this.date,
    required this.isSent,
    this.method,
    this.attendance,
    this.memo,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 📥 Firestore Map → EventRecord 객체 변환
  factory EventRecord.fromMap(Map<String, dynamic> map) {
    return EventRecord(
      id: map['id'] as String,
      friendId: map['friendId'] as String,
      eventId: map['eventId'] as String,
      eventType: map['eventType'] != null
          ? EventType.values.firstWhere(
              (e) => e.name == map['eventType'],
              orElse: () => EventType.etc,
            )
          : null,
      amount: map['amount'] as int,
      date: DateTime.parse(map['date'] as String),
      isSent: map['isSent'] as bool,
      method: map['method'] != null
          ? MethodType.values.firstWhere(
              (e) => e.name == map['method'],
            )
          : null,
      attendance: map['attendance'] != null
          ? AttendanceType.values.firstWhere(
              (e) => e.name == map['attendance'],
            )
          : null,
      memo: map['memo'] as String?,
      createdBy: map['createdBy'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  /// 📤 EventRecord 객체 → Firestore에 저장 가능한 Map 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'friendId': friendId,
      'eventId': eventId,
      'eventType': eventType?.name,
      'amount': amount,
      'date': date.toIso8601String(),
      'isSent': isSent,
      'method': method?.name,
      'attendance': attendance?.name,
      'memo': memo,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// 🔧 일부 필드만 교체해 새 객체 반환
  EventRecord copyWith({
    EventType? eventType,
    int? amount,
    DateTime? date,
    bool? isSent,
    MethodType? method,
    AttendanceType? attendance,
    String? memo,
    DateTime? updatedAt,
  }) {
    return EventRecord(
      id: id,
      friendId: friendId,
      eventId: eventId,
      eventType: eventType ?? this.eventType,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      isSent: isSent ?? this.isSent,
      method: method ?? this.method,
      attendance: attendance ?? this.attendance,
      memo: memo ?? this.memo,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
