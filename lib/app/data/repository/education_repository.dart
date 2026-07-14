
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
class EducationRepository {
  Future<dynamic> addEducation(dynamic body) async {
    try {
      final response = await ApiClient.client.post(
        APIEndpoints.addEducation,
        body,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> updateEducation(dynamic body) async {
    try {
      final response = await ApiClient.client.put(
        APIEndpoints.editEducation,
        body,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}