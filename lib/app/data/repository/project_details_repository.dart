import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class ProjectDetailsRepository {
  Future<dynamic> getUser() async {
    try {
      final response = await ApiClient.client.get(
        APIEndpoints.getUser,
      );

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> addProject(dynamic body) async {
    try {
      final response = await ApiClient.client.post(
        APIEndpoints.addProject,
        body,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> updateProjects(dynamic body) async {
    try {
      final response = await ApiClient.client.put(
        APIEndpoints.editProject,
        body,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> deleteProject(dynamic body) async {
    try {
      final response = await ApiClient.client.delete(
        APIEndpoints.deleteProject,
        body: body,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}