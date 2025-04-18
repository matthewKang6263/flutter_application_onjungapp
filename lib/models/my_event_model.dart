import 'package:flutter_application_onjungapp/models/enums/event_type.dart';

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

  /// ✅ 수정된 copyWith 메서드 (flowerFriendNames 포함)
  MyEvent copyWith({
    String? title,
    EventType? eventType,
    DateTime? date,
    DateTime? updatedAt,
    List<String>? flowerFriendNames,
    List<String>? recordIds,
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

  factory MyEvent.fromMap(Map<String, dynamic> map) => MyEvent(
        id: map['id'],
        title: map['title'],
        eventType:
            EventType.values.firstWhere((e) => e.name == map['eventType']),
        date: DateTime.parse(map['date']),
        createdBy: map['createdBy'],
        createdAt: DateTime.parse(map['createdAt']),
        updatedAt: DateTime.parse(map['updatedAt']),
        recordIds: List<String>.from(map['recordIds']),
        flowerFriendNames: List<String>.from(map['flowerFriendNames']),
      );

  Map<String, dynamic> toMap() => {
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
