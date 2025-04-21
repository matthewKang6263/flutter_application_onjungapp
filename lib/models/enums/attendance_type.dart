// lib/models/enums/attendance_type.dart

/// 🔹 참석 여부 유형
enum AttendanceType {
  attended,
  notAttended,
}

/// 🔸 AttendanceType 확장: UI 표시용 한글 라벨
extension AttendanceTypeLabel on AttendanceType {
  String get label {
    switch (this) {
      case AttendanceType.attended:
        return '참석';
      case AttendanceType.notAttended:
        return '미참석';
    }
  }

  /// 🔹 문자열 → AttendanceType 변환 (디폴트 notAttended)
  static AttendanceType fromString(String? value) {
    switch (value) {
      case 'attended':
        return AttendanceType.attended;
      case 'notAttended':
      default:
        return AttendanceType.notAttended;
    }
  }
}

extension AttendanceTypeParser on AttendanceType {
  /// 한글 레이블 → enum
  static AttendanceType fromLabel(String label) {
    switch (label) {
      case '참석':
        return AttendanceType.attended;
      case '미참석':
      default:
        return AttendanceType.notAttended;
    }
  }
}
