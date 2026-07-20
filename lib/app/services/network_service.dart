import '../data/network/api_client.dart';

class NetworkService {

  static Future<bool> hasInternet() async {
    return ApiClient.client.isConnected();
  }

}