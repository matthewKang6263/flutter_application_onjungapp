import 'package:flutter_application_onjungapp/models/enums/attendance_type.dart';
import 'package:flutter_application_onjungapp/models/enums/method_type.dart';
import 'package:flutter_application_onjungapp/models/enums/event_type.dart';

class EventRecord {
  final String id;
  final String friendId;
  final String eventId;

  /// ✅ 새로 추가된 필드
  final EventType? eventType;

  final int amount;
  final DateTime date;
  final bool isSent;
  final MethodType? method;
  final AttendanceType? attendance;
  final String? memo;
  final String createdBy;
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

  factory EventRecord.fromMap(Map<String, dynamic> map) => EventRecord(
        id: map['id'],
        friendId: map['friendId'],
        eventId: map['eventId'],
        eventType: map['eventType'] != null
            ? EventType.values.firstWhere((e) => e.name == map['eventType'])
            : null,
        amount: map['amount'],
        date: DateTime.parse(map['date']),
        isSent: map['isSent'],
        method: map['method'] != null
            ? MethodType.values.firstWhere((e) => e.name == map['method'])
            : null,
        attendance: map['attendance'] != null
            ? AttendanceType.values
                .firstWhere((e) => e.name == map['attendance'])
            : null,
        memo: map['memo'],
        createdBy: map['createdBy'],
        createdAt: DateTime.parse(map['createdAt']),
        updatedAt: DateTime.parse(map['updatedAt']),
      );

  Map<String, dynamic> toMap() => {
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

  EventRecord copyWith({
    String? id,
    String? friendId,
    String? eventId,
    EventType? eventType,
    int? amount,
    DateTime? date,
    bool? isSent,
    MethodType? method,
    AttendanceType? attendance,
    String? memo,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EventRecord(
      id: id ?? this.id,
      friendId: friendId ?? this.friendId,
      eventId: eventId ?? this.eventId,
      eventType: eventType ?? this.eventType,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      isSent: isSent ?? this.isSent,
      method: method ?? this.method,
      attendance: attendance ?? this.attendance,
      memo: memo ?? this.memo,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
