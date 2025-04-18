import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';

class Friend {
  final String id;
  final String name;
  final String? phone;
  final RelationType? relation;
  final String? memo;
  final String ownerId;
  final DateTime createdAt;

  Friend({
    required this.id,
    required this.name,
    this.phone,
    this.relation,
    this.memo,
    required this.ownerId,
    required this.createdAt,
  });

  Friend copyWith({
    String? id,
    String? name,
    String? phone,
    RelationType? relation,
    String? memo,
    String? ownerId,
    DateTime? createdAt,
  }) {
    return Friend(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      relation: relation ?? this.relation,
      memo: memo ?? this.memo,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      relation: RelationTypeExtension.fromString(map['relation']),
      memo: map['memo'],
      ownerId: map['ownerId'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'relation': relation?.name,
      'memo': memo,
      'ownerId': ownerId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
