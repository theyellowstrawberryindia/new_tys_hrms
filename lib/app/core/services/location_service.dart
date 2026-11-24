/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 5:16 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 5:16 pm
 *
 */

import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

enum LocationAccessStatus {
  granted,
  servicesDisabled,
  permissionDenied,
  reducedAccuracy;

  String get message => switch (this) {
    servicesDisabled => "Turn on Location Services in Settings.",
    permissionDenied => "Allow location access in Settings.",
    reducedAccuracy => "Enable Precise Location in Settings.",
    granted => "",
  };

  Future<bool> openSettings() => switch (this) {
    servicesDisabled => Geolocator.openLocationSettings(),
    permissionDenied || reducedAccuracy => Geolocator.openAppSettings(),
    granted => Future.value(false),
  };
}

class LocationService {
  static const attendanceFixMaxAge = Duration(seconds: 15);

  static bool isRecentAttendanceFix(Position position, DateTime now) {
    final age = now.difference(position.timestamp);
    return !age.isNegative && age <= attendanceFixMaxAge;
  }

  static Future<Position?> getAttendancePosition({
    required bool Function(Position) isUsable,
  }) async {
    const timeLimit = Duration(seconds: 8);
    final elapsed = Stopwatch()..start();
    Position? lastRecentPosition;
    while (true) {
      final timeRemaining = timeLimit - elapsed.elapsed;
      if (timeRemaining <= Duration.zero) break;
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          timeLimit: timeRemaining,
        );
        if (isRecentAttendanceFix(position, DateTime.now())) {
          lastRecentPosition = position;
          if (isUsable(position)) return position;
        }
      } on TimeoutException {
        break;
      }
      final remaining = timeLimit - elapsed.elapsed;
      const retryDelay = Duration(milliseconds: 500);
      if (remaining > Duration.zero) {
        await Future<void>.delayed(
          remaining < retryDelay ? remaining : retryDelay,
        );
      }
    }
    return lastRecentPosition;
  }

  static Future<LocationAccessStatus> checkAccess({
    bool requestPermission = true,
    bool requirePrecise = false,
  }) async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationAccessStatus.servicesDisabled;
    }

    var permission = await Geolocator.checkPermission();
    if (requestPermission && permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return LocationAccessStatus.permissionDenied;
    }
    if (requirePrecise &&
        await Geolocator.getLocationAccuracy() ==
            LocationAccuracyStatus.reduced) {
      return LocationAccessStatus.reducedAccuracy;
    }
    return LocationAccessStatus.granted;
  }

  /// LOCATION STREAM
  static Stream<Position> getPositionStream() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,

      distanceFilter: 5,
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  /// DISTANCE
  static double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// ADDRESS
  static Future<String> getAddressFromLatLng({
    required double latitude,
    required double longitude,
  }) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}";
      }

      return "Unknown location";
    } catch (e) {
      return "Location unavailable";
    }
  }
}
