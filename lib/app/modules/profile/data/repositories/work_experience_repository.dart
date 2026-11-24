import '../../../../data/network/api_client.dart';
import '../../../../data/network/api_endpoints.dart';

class WorkExperienceRepository {
  WorkExperienceRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient.client;

  final ApiClient _apiClient;

  Future<dynamic> getUser() async {
    try {
      final response = await _apiClient.get(APIEndpoints.getUser);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> addWorkExperience(dynamic body) async {
    try {
      final response = await _apiClient.post(
        APIEndpoints.addWork,
        body,
        preserveErrors: true,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> updateWorkExperience(dynamic body) async {
    try {
      final response = await _apiClient.put(
        APIEndpoints.editWork,
        body,
        preserveErrors: true,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> deleteWorkExperience(dynamic body) async {
    try {
      final response = await _apiClient.delete(
        APIEndpoints.deleteWork,
        body: body,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}
