import 'package:hrms_ys/app/core/core.dart';


class LeaveDataRepository {

  Future<dynamic> getLeaveTermStatus({int? year}) {
    return ApiClient.client.get(
      APIEndpoints.termStatusEndpoint,
      query: {
        if (year != null) 'year': year,
      },
    );
  }

  Future<dynamic> getLeaveTermDetails(int termId) {
    return ApiClient.client.get(
      APIEndpoints.termDetailsEndpoint,
      query: {
        'termId': termId,
      },
    );
  }
}