
import 'package:hrms_ys/app/core/core.dart';


class PolicyRepository {
  Future<Map<String, dynamic>> getPolicy() async {
    final response = await ApiClient.client.get(APIEndpoints.getPolicy);
    return Map<String, dynamic>.from(response);
  }

  Future<Map<String, dynamic>> acceptPolicy(Map<String, dynamic> body) async {
    final response = await ApiClient.client.post(APIEndpoints.acceptPolicy, body);
    return Map<String, dynamic>.from(response);
  }
}