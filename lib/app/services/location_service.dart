/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 5:16 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 5:16 pm
 *
 */

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hrms_ys/app/core/core.dart';

class LocationService {
  /// HANDLE PERMISSION
  static Future<bool> handlePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
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
