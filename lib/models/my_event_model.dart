// lib/models/my_event_model.dart

import 'package:flutter_application_onjungapp/models/enums/event_type.dart';

/// 🔹 나의 경조사 이벤트 모델
/// - 하나의 행사(결혼식·돌잔치 등)에 대한 메타데이터와
///   관련된 상세내역(ID 리스트, 화환친구 리스트 등)를 관리
class MyEvent {
  final String id;
  final String title;
  final EventType eventType;
  final DateTime date;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> recordIds;
  final List<String> flowerFriendNames;

  MyEvent({
    required this.id,
    required this.title,
    required this.eventType,
    required this.date,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.recordIds,
    required this.flowerFriendNames,
  });

  /// 🔧 일부 필드만 교체해 새 객체 반환 (immutable 패턴)
  /// - updatedAt은 전달 없을 시 `DateTime.now()` 적용
  MyEvent copyWith({
    String? title,
    EventType? eventType,
    DateTime? date,
    DateTime? updatedAt,
    List<String>? recordIds,
    List<String>? flowerFriendNames,
  }) {
    return MyEvent(
      id: id,
      title: title ?? this.title,
      eventType: eventType ?? this.eventType,
      date: date ?? this.date,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      recordIds: recordIds ?? this.recordIds,
      flowerFriendNames: flowerFriendNames ?? this.flowerFriendNames,
    );
  }

  /// 📥 Firestore Map → MyEvent 객체 변환
  factory MyEvent.fromMap(Map<String, dynamic> map) {
    return MyEvent(
      id: map['id'] as String,
      title: map['title'] as String,
      eventType: EventType.values.firstWhere(
        (e) => e.name == map['eventType'],
        orElse: () => EventType.etc,
      ),
      date: DateTime.parse(map['date'] as String),
      createdBy: map['createdBy'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      recordIds: List<String>.from(map['recordIds'] as List),
      flowerFriendNames: List<String>.from(map['flowerFriendNames'] as List),
    );
  }

  /// 📤 MyEvent 객체 → Firestore에 저장 가능한 Map 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'eventType': eventType.name,
      'date': date.toIso8601String(),
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'recordIds': recordIds,
      'flowerFriendNames': flowerFriendNames,
    };
  }
}
