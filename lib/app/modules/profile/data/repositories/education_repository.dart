import '../../../../data/network/api_client.dart';
import '../../../../data/network/api_endpoints.dart';

class EducationRepository {
  EducationRepository({ApiClient? apiClient})
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

  Future<dynamic> addEducation(dynamic body) async {
    try {
      final response = await _apiClient.post(
        APIEndpoints.addEducation,
        body,
        preserveErrors: true,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> updateEducation(dynamic body) async {
    try {
      final response = await _apiClient.put(
        APIEndpoints.editEducation,
        body,
        preserveErrors: true,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> deleteEducation(dynamic body) async {
    try {
      final response = await _apiClient.delete(
        APIEndpoints.deleteEducation,
        body: body,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}
