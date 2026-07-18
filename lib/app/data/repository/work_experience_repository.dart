import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class WorkExperienceRepository {
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

  Future<dynamic> addWorkExperience(dynamic body) async {
    try {
      final response = await ApiClient.client.post(
        APIEndpoints.addWork,
        body,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> updateWorkExperience(dynamic body) async {
    try {
      final response = await ApiClient.client.put(
        APIEndpoints.editWork,
        body,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> deleteWorkExperience(dynamic body) async {
    try {
      final response = await ApiClient.client.delete(
        APIEndpoints.deleteWork,
        body: body,
      );
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}