import 'dart:convert';

LeaveTermStatusResponse leaveTermStatusResponseFromJson(String str) =>
    LeaveTermStatusResponse.fromJson(json.decode(str));

int _safeInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  return int.tryParse(v.toString()) ?? 0;
}

DateTime? _safeDate(dynamic v) {
  if (v == null) return null;
  return DateTime.tryParse(v.toString());
}

class LeaveTermStatusResponse {
  final bool success;
  final int statusCode;
  final List<LeaveTerm> data;
  final String message;

  LeaveTermStatusResponse({
    required this.success,
    required this.statusCode,
    required this.data,
    required this.message,
  });

  factory LeaveTermStatusResponse.fromJson(Map<String, dynamic> json) =>
      LeaveTermStatusResponse(
        success: json["success"] ?? false,
        statusCode: _safeInt(json["status_code"]),
        data: (json["data"] as List? ?? [])
            .map((e) => LeaveTerm.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        message: json["message"]?.toString() ?? '',
      );
}

class LeaveTerm {
  final int id;
  final int userid;
  final String email;
  final DateTime? termStartDate;
  final DateTime? termEndDate;
  final String term; // e.g. "2025-2026"
  final int prevYearBalLeave;
  final int prevYearUsedLeave;
  final int prevYearAssignedLeave;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  LeaveTerm({
    required this.id,
    required this.userid,
    required this.email,
    required this.termStartDate,
    required this.termEndDate,
    required this.term,
    required this.prevYearBalLeave,
    required this.prevYearUsedLeave,
    required this.prevYearAssignedLeave,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LeaveTerm.fromJson(Map<String, dynamic> json) => LeaveTerm(
    id: _safeInt(json["id"]),
    userid: _safeInt(json["userid"]),
    email: json["email"]?.toString() ?? '',
    termStartDate: _safeDate(json["term_start_date"]),
    termEndDate: _safeDate(json["term_end_date"]),
    term: json["term"]?.toString() ?? '',
    prevYearBalLeave: _safeInt(json["prev_year_bal_leave"]),
    prevYearUsedLeave: _safeInt(json["prev_year_used_leave"]),
    prevYearAssignedLeave: _safeInt(json["prev_year_assigned_leave"]),
    createdAt: _safeDate(json["created_at"]),
    updatedAt: _safeDate(json["updated_at"]),
  );

  String get label => term;

}