/*
 *  Created by Yellow Strawberry LLP on 27/05/26, 4:22 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 27/05/26, 4:22 pm
 *
 */

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static Future<Map<String, dynamic>> getDeviceData() async {
    String deviceOS = "";
    String deviceName = "";
    String osVersion = "";

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;

      deviceOS = "Android ${androidInfo.version.release}";

      deviceName = androidInfo.model;

      osVersion = "${androidInfo.version.baseOS}";
    }

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;

      deviceOS = "iOS ${iosInfo.systemVersion}";

      deviceName = iosInfo.name;

      osVersion = iosInfo.systemVersion;

    }

    return {"device_os": deviceOS, "device_name": deviceName , "os_version":osVersion};
  }
}
