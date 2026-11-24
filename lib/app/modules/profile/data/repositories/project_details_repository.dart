import '../../../../data/network/api_client.dart';
import '../../../../data/network/api_endpoints.dart';

class ProjectDetailsRepository {
  ProjectDetailsRepository({ApiClient? apiClient})
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

  Future<dynamic> addProject(dynamic body) async {
    try {
      final response = await _apiClient.post(
        APIEndpoints.addProject,
        body,
        preserveErrors: true,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> updateProjects(dynamic body) async {
    try {
      final response = await _apiClient.put(
        APIEndpoints.editProject,
        body,
        preserveErrors: true,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> deleteProject(dynamic body) async {
    try {
      final response = await _apiClient.delete(
        APIEndpoints.deleteProject,
        body: body,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}
