// lib/models/friend_model.dart

import 'package:flutter_application_onjungapp/models/enums/relation_type.dart';

/// 🔹 친구 모델
/// - 연락처나 직접 추가된 친구 정보를 관리
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

  /// 🔧 일부 필드만 교체해 새 객체 반환
  Friend copyWith({
    String? name,
    String? phone,
    RelationType? relation,
    String? memo,
  }) {
    return Friend(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      relation: relation ?? this.relation,
      memo: memo ?? this.memo,
      ownerId: ownerId,
      createdAt: createdAt,
    );
  }

  /// 📥 Firestore Map → Friend 객체 변환
  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String?,
      relation: RelationTypeExtension.fromString(map['relation'] as String?),
      memo: map['memo'] as String?,
      ownerId: map['ownerId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  /// 📤 Friend 객체 → Firestore에 저장 가능한 Map 변환
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
