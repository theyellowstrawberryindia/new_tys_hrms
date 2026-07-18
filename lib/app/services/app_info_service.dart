import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  static Future<String> version() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  static Future<String> buildNumber() async {
    final info = await PackageInfo.fromPlatform();
    return info.buildNumber;
  }

  static Future<String> fullVersion() async {
    final info = await PackageInfo.fromPlatform();
    return "${info.version} (${info.buildNumber})";
  }
}