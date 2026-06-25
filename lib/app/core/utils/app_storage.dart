/*
 *  Created by Yellow Strawberry LLP on 21/05/26, 7:10 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 21/05/26, 7:10 pm
 *
 */

import 'package:get_storage/get_storage.dart';

import '../../data/models/current_user.dart';
import '../configs/app_configs.dart';


class AppStorage {
  AppStorage._();

  static final AppStorage _instance = AppStorage._();

  static AppStorage get instance => _instance;

  static final GetStorage _storage = GetStorage(AppConfig.appStorageName);

  /// Store any data by key
  void setValue(String key, dynamic data) {
    _storage.write(key, data);
  }

  // Retrieve any data by key
  dynamic valueFor(String key) {
    return _storage.read(key);
  }

  static void setIsLoggedIn(bool value) {
    _storage.write(StorageKey.isLoggedIn, value);
  }

  static bool isLoggedIn() {
    return _storage.read(StorageKey.isLoggedIn) ?? false;
  }

  static void setUserToken(String value) {
    _storage.write(StorageKey.accessToken, value);
  }

  static String getUserToken() {
    return _storage.read(StorageKey.accessToken) ?? "";
  }


  /// Remove specific key
  void remove(String key) {
    _storage.remove(key);
  }

  /// Clear all saved data
  void clearAll() {
    _storage.erase();
  }

  void setUserData(CurrentUser user) async {
    await _storage.write(StorageKey.userData, user.toJson());
  }
  CurrentUser getUserData() {
    final rawData = _storage.read(StorageKey.userData) ?? {};
    final Map<String, dynamic> data =Map<String, dynamic>.from(rawData);
    return CurrentUser.fromJson(data);
  }

  /// PROFILE IMAGE
  void setProfileImage(String value) {
    _storage.write(StorageKey.profileImage, value);
  }

  String getProfileImage() {
    return _storage.read(StorageKey.profileImage) ?? "";
  }

  void clearProfileImage() {
    _storage.remove(StorageKey.profileImage);
  }
}

class StorageKey {
  static const String userData = 'user_data';
  static const String isLoggedIn = 'is_logged_in';
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String firebaseToken = 'firebase_token';
  static const String themeMode = 'theme_mode';
  static const String profileImage = 'profile_image';

}
