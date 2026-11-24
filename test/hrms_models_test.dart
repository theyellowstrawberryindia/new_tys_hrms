import 'package:flutter_test/flutter_test.dart';
import 'package:hrms_ys/app/modules/attendance/data/models/attendance_list.dart';
import 'package:hrms_ys/app/modules/leave/data/models/leave_data.dart';

void main() {
  test('attendance parses summary and a record without a checkout', () {
    final response = AttendanceListResponse.fromJson({
      'success': true,
      'status_code': 200,
      'data': [
        {'att_date': '2026-11-24', 'att_status': 'Present', 'in_time': '09:00'},
      ],
      'attendanceCount': {'presentCount': 1, 'workingDays': 20},
    });

    expect(response.data.single.attDate, '2026-11-24');
    expect(response.data.single.inTime, '09:00');
    expect(response.data.single.outTime, isNull);
    expect(response.attendanceCount?.presentCount, 1);
    expect(response.attendanceCount?.workingDays, 20);
  });

  test('attendance tolerates missing records and summary', () {
    final response = AttendanceListResponse.fromJson({'success': true});

    expect(response.data, isEmpty);
    expect(response.attendanceCount, isNull);
  });

  test('leave terms parse fractional balances and optional dates', () {
    final response = LeaveTermStatusResponse.fromJson({
      'status_code': '200',
      'data': [
        {
          'id': '4',
          'term_start_date': '2026-04-01',
          'term_end_date': 'invalid',
          'prev_year_bal_leave': '2.5',
          'prev_year_used_leave': 1.5,
        },
      ],
    });

    final term = response.data.single;
    expect(response.statusCode, 200);
    expect(term.id, 4);
    expect(term.termStartDate, DateTime(2026, 4, 1));
    expect(term.termEndDate, isNull);
    expect(term.prevYearBalLeave, 2.5);
    expect(term.prevYearUsedLeave, 1.5);
    expect(term.prevYearAssignedLeave, 0);
  });
}
