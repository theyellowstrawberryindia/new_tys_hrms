import 'attendance_repository.dart';

class LeaveDataRepository {
  final AttendanceRepository _attendanceRepository = AttendanceRepository();

  Future<dynamic> getLeaveDataForMonth(int year, String month) {
    return _attendanceRepository.getAttendance({
      'year': year,
      'month': month,
    });
  }
}