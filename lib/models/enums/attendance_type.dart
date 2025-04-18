/// 🔹 참석 여부
enum AttendanceType {
  attended,
  notAttended,
}

/// 🔸 한글 라벨 반환용 확장
extension AttendanceTypeLabel on AttendanceType {
  String get label {
    switch (this) {
      case AttendanceType.attended:
        return '참석';
      case AttendanceType.notAttended:
        return '미참석';
    }
  }
}
