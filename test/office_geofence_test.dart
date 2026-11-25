import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hrms_ys/app/core/services/location_service.dart';
import 'package:hrms_ys/app/modules/attendance/services/office_geofence.dart';

void main() {
  final messenger =
      TestWidgetsFlutterBinding.ensureInitialized().defaultBinaryMessenger;
  const locationChannel = MethodChannel('flutter.baseflow.com/geolocator');

  void mockLocation(Map<String, Object> responses, List<String> calls) {
    messenger.setMockMethodCallHandler(locationChannel, (call) async {
      calls.add(call.method);
      return responses[call.method];
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(locationChannel, null),
    );
  }

  test('denied permission opens the app settings', () async {
    final calls = <String>[];
    mockLocation({
      'isLocationServiceEnabled': true,
      'checkPermission': LocationPermission.denied.index,
      'requestPermission': LocationPermission.denied.index,
      'openAppSettings': true,
    }, calls);

    final access = await LocationService.checkAccess();
    expect(access, LocationAccessStatus.permissionDenied);
    expect(await access.openSettings(), isTrue);
    expect(calls, [
      'isLocationServiceEnabled',
      'checkPermission',
      'requestPermission',
      'openAppSettings',
    ]);
  });

  test('disabled services opens system location settings', () async {
    final calls = <String>[];
    mockLocation({
      'isLocationServiceEnabled': false,
      'openLocationSettings': true,
    }, calls);

    final access = await LocationService.checkAccess();
    expect(access, LocationAccessStatus.servicesDisabled);
    expect(await access.openSettings(), isTrue);
    expect(calls, ['isLocationServiceEnabled', 'openLocationSettings']);
  });

  test('checking after Settings honors denied or approximate access', () async {
    final calls = <String>[];
    final responses = <String, Object>{
      'isLocationServiceEnabled': true,
      'checkPermission': LocationPermission.denied.index,
      'getLocationAccuracy': LocationAccuracyStatus.reduced.index,
      'openAppSettings': true,
    };
    mockLocation(responses, calls);

    expect(
      await LocationService.checkAccess(requestPermission: false),
      LocationAccessStatus.permissionDenied,
    );
    expect(calls, isNot(contains('requestPermission')));

    responses['checkPermission'] = LocationPermission.whileInUse.index;
    final access = await LocationService.checkAccess(requirePrecise: true);
    expect(access, LocationAccessStatus.reducedAccuracy);
    expect(await access.openSettings(), isTrue);
    expect(calls.last, 'openAppSettings');

    responses['getLocationAccuracy'] = LocationAccuracyStatus.precise.index;
    expect(
      await LocationService.checkAccess(
        requestPermission: false,
        requirePrecise: true,
      ),
      LocationAccessStatus.granted,
    );
  });

  OfficeLocationStatus assess(double distance, double accuracy) =>
      assessOfficeLocation(
        distance: distance,
        horizontalAccuracy: accuracy,
        radius: 40,
      );

  test('allows a usable fix within the full configured radius', () {
    expect(assess(12, 5), OfficeLocationStatus.inside);
    expect(assess(30, 10), OfficeLocationStatus.inside);
    expect(assess(35, 10), OfficeLocationStatus.inside);
    expect(assess(40, 20), OfficeLocationStatus.inside);
  });

  test(
    'rejects a reliable outside fix and treats poor accuracy as uncertain',
    () {
      expect(assess(100, 10), OfficeLocationStatus.outside);
      expect(assess(100, 100), OfficeLocationStatus.uncertain);
      expect(assess(3, 100), OfficeLocationStatus.uncertain);
    },
  );

  test('treats boundary overlaps and invalid accuracy as uncertain', () {
    expect(assess(45, 10), OfficeLocationStatus.uncertain);
    expect(assess(10, 0), OfficeLocationStatus.uncertain);
    expect(assess(20, double.nan), OfficeLocationStatus.uncertain);
  });

  test('only recent, non-future fixes are eligible for attendance', () {
    final now = DateTime.utc(2026, 11, 24, 8);
    Position positionAt(DateTime timestamp) => Position(
      longitude: 73,
      latitude: 19,
      timestamp: timestamp,
      accuracy: 10,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );

    bool isRecent(Duration age) => LocationService.isRecentAttendanceFix(
      positionAt(now.subtract(age)),
      now,
    );
    expect(isRecent(const Duration(seconds: 15)), isTrue);
    expect(isRecent(const Duration(seconds: 16)), isFalse);
    expect(isRecent(const Duration(seconds: -1)), isFalse);
  });
}
