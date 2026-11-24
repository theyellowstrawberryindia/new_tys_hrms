/*
 *  Created by Yellow Strawberry LLP on 25/05/26, 2:36 pm
 *  Copyright (c) 2026 . All rights reserved.
 *  Last modified 25/05/26, 2:36 pm
 *
 */

import 'dart:io';

import 'package:hrms_ys/app/core/core.dart';
import 'package:hrms_ys/app/core/utils/app_storage.dart';
import 'package:hrms_ys/app/modules/profile/controllers/profile_controller.dart';
import 'package:hrms_ys/app/modules/attendance/widgets/common_attendance_popup.dart';
import 'package:hrms_ys/app/shared/widgets/common_confirmation_dialog.dart';

import '../../../shared/packages.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import '../../auth/views/auth_screen.dart';
import '../../attendance/services/office_geofence.dart';
import '../../attendance/views/attendance_camera_screen.dart';
import '../../../core/services/device_info_service.dart';
import '../../../core/services/location_service.dart';

import 'package:geolocator/geolocator.dart';
import '../../../core/services/network_service.dart';
import '../../profile/widgets/policy_acceptance_dialog.dart';
import '../../auth/bindings/auth_binding.dart';
import '../../attendance/data/models/attendance_data.dart';
import '../../../data/models/current_user.dart';
import '../data/repositories/home_repository.dart';
import '../../profile/controllers/privacy_policy_controller.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final homeRepository = HomeRepository();

  /// TIME
  String currentTime = "";
  String currentDate = "";

  /// LOCATION
  String officeDistance = "Getting Location...";
  String currentAddress = "";
  LocationAccessStatus? locationSettingsTarget;
  OfficeLocationStatus? lastOfficeLocationStatus;
  bool isVerifyingOfficeLocation = false;
  late final AppLifecycleListener _locationLifecycleListener;
  bool _refreshLocationAfterSettings = false;

  Position? currentPosition;

  /// OFFICE LOCATION
  final double officeLat = 19.0667379;
  final double officeLng = 73.0082772;
  static const double officeRadius = 40;

  /// OFFICE STATUS
  bool isInsideOfficeRadius = false;
  bool canClockIn = false;

  Timer? timer;

  StreamSubscription<Position>? positionStream;

  ///CURRENT USER
  CurrentUser? currentUser;

  /// ATTENDANCE UI
  Attendance? todayAttendance;

  bool isCheckedIn = false;

  bool isCheckedOut = false;

  bool isLateCheckIn = false;

  String checkInTime = "--:--";

  String checkOutTime = "--:--";

  String totalHours = "--:--";

  String liveTotalHours = "--:--";

  String attendanceDate = "";

  bool _loaded = false;

  /// ANIMATIONS
  ///
  late AnimationController buttonPressController;

  late AnimationController pulseController;

  late Animation<double> buttonPressAnimation;

  late Animation<double> pulseAnimation;

  bool isButtonPressed = false;

  /// STATS CARD ANIMATION
  ///

  late AnimationController statsIconController;

  late Animation<double> clockInRotation;

  late Animation<double> clockOutRotation;

  late Animation<double> totalHourRotation;

  late Animation<double> cardElevation;

  bool isOpeningCamera = false;

  bool isUserLoaded = false;

  bool _isOfficeEmployee = false;

  bool get isOfficeEmployee => _isOfficeEmployee;


  bool get shouldShowCheckoutConfirmation {
    return isCheckedIn;
  }

  bool get _isUserInactive {
    if (currentUser == null || currentUser!.data.isEmpty) return false;

    return currentUser!.data.first.isInactive;
  }
  bool _isLoggingOut = false;

  String get attendanceConfirmationMessage {
    if (!isCheckedIn) {
      return "";
    }

    if (isCheckedOut) {
      return "You have already checked out today. Do you want to update your check-out time?";
    }

    return "Are you ready to check-out at this time?";
  }

  // bool get isOfficeEmployee {
  //   return currentUser?.data.first.workLocation?.toLowerCase().trim() ==
  //       "office";
  // }

  @override
  void onInit() {
    super.onInit();

    _updateTime();

    _startClock();

    _locationLifecycleListener = AppLifecycleListener(
      onResume: () {
        if (!_refreshLocationAfterSettings || isClosed) return;
        _refreshLocationAfterSettings = false;
        unawaited(startLocationListener(requestPermission: false));
      },
    );
    startLocationListener();

    _initAnimations();
  }

  @override
  Future<void> onReady() async {
    super.onReady();

    final connected = await NetworkService.hasInternet();

    if (!connected) {
      Toast.error(
        message: "Looks like you are not connected to internet.",
      );
      return;
    }

    final isActive = await _getUser();
    if (!isActive) return;

    /// SHOW PRIVACY POLICY GATE
    await showPolicyAcceptanceDialog();

    _getTodaysAttendance();
  }
  Future<void> loadData() async {
    if (_loaded) return;
    _loaded = true;
    // _getUser();
    // _getTodaysAttendance();
  }

  bool _isPolicyDialogShowing = false;

  Future<void> showPolicyAcceptanceDialog() async {
    if (_isPolicyDialogShowing) return;

    if (currentUser == null ||
        currentUser!.professionalDetails.isEmpty) {
      return;
    }

    /// User already accepted policy.
    if (currentUser!
        .professionalDetails
        .first
        .isPolicyAccepted ==
        1) {
      return;
    }

    /// PolicyAcceptanceDialog is a GetView<PolicyController> — make sure the
    /// controller exists before the dialog tries to find it. It's normally
    /// only registered via PrivacyPolicyBinding when navigating to that
    /// screen directly, but the dashboard gate can fire before that route
    /// is ever visited.
    if (!Get.isRegistered<PolicyController>()) {
      Get.put(PolicyController());
    }

    _isPolicyDialogShowing = true;

    await Get.dialog(
      const PolicyAcceptanceDialog(),

      /// Cannot dismiss by tapping outside.
      barrierDismissible: false,
    );

    _isPolicyDialogShowing = false;
  }

  /// Refresh
  Future<void> refreshHome() async {

    if (!await NetworkService.hasInternet()) {

      Toast.error(
        message: "Looks like you are not connected to internet.",
      );

      return;
    }

    await positionStream?.cancel();

    await startLocationListener();

    await _getUser();
  }

  void _initAnimations() {
    /// Button Press
    buttonPressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );

    buttonPressAnimation = Tween<double>(begin: 1, end: .92).animate(
      CurvedAnimation(parent: buttonPressController, curve: Curves.easeOut),
    );

    /// Pulse
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    pulseAnimation = Tween<double>(begin: 1, end: 1.06).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOutCubic),
    );

    startPulse();

    /// Stats Icon Animation
    statsIconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    clockInRotation = Tween<double>(begin: -.08, end: .08).animate(
      CurvedAnimation(
        parent: statsIconController,
        curve: const Interval(0.0, .35, curve: Curves.easeInOut),
      ),
    );

    clockOutRotation = Tween<double>(begin: -.08, end: .08).animate(
      CurvedAnimation(
        parent: statsIconController,
        curve: const Interval(.20, .60, curve: Curves.easeInOut),
      ),
    );

    totalHourRotation = Tween<double>(begin: -.08, end: .08).animate(
      CurvedAnimation(
        parent: statsIconController,
        curve: const Interval(.45, 1, curve: Curves.easeInOut),
      ),
    );

    _startStatsAnimation();
  }

  Future<void> startPulse() async {
    while (!isClosed) {
      /// Stop pulse after check-in
      if (attendanceButtonText == "Check Out") {
        pulseController.stop();
        break;
      }

      await pulseController.forward();

      await pulseController.reverse();

      await Future.delayed(const Duration(milliseconds: 2500));
    }
  }

  Future<void> _startStatsAnimation() async {
    while (!isClosed) {
      await Future.delayed(const Duration(seconds: 4));

      if (isClosed) break;

      await statsIconController.forward();

      await statsIconController.reverse();
    }
  }

  void onButtonTapDown() {
    if (isButtonPressed) {
      return;
    }

    isButtonPressed = true;

    buttonPressController.forward();
  }

  void onButtonTapUp() {
    if (!isButtonPressed) {
      return;
    }

    isButtonPressed = false;

    /// Restore button immediately.
    buttonPressController.reverse();

    /// Open camera immediately.
    createAttendance();
  }

  void onButtonTapCancel() {
    isButtonPressed = false;

    buttonPressController.reverse();
  }

  /// CLOCK
  void _startClock() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  /// UPDATE TIME
  void _updateTime() {
    final now = DateTime.now();

    currentTime = DateFormat("HH:mm:ss").format(now);

    currentDate = DateFormat("EEEE | MMM dd").format(now);

    validateAttendanceDay();

    _updateLiveTotalHours();

    update();
  }
  ///live counter
  void _updateLiveTotalHours() {
    /// FROZEN — checkout already happened
    if (isCheckedOut) {
      final parts = totalHours.split(":");

      if (parts.length == 2) {
        liveTotalHours = "$totalHours:00";
      } else {
        liveTotalHours = totalHours;
      }

      return;
    }

    /// NOT CHECKED IN YET
    if (!isCheckedIn ||
        checkInTime == "--:--" ||
        checkInTime.isEmpty) {
      liveTotalHours = "--:--";
      return;
    }

    try {
      final now = DateTime.now();

      final inParts = checkInTime.split(":");

      final checkInDate = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(inParts[0]),
        int.parse(inParts[1]),
        int.parse(inParts[2]),
      );

      var diff = now.difference(checkInDate);

      if (diff.isNegative) {
        diff = Duration.zero;
      }

      final hours = diff.inHours.toString().padLeft(2, '0');
      final minutes =
      (diff.inMinutes % 60).toString().padLeft(2, '0');
      final seconds =
      (diff.inSeconds % 60).toString().padLeft(2, '0');

      /// LIVE COUNTER
      liveTotalHours = "$hours:$minutes:$seconds";
    } catch (e) {
      liveTotalHours = totalHours;
    }
  }
  /// ATTENDANCE UI

  void updateAttendanceUI(Map<String, dynamic> response) {
    ///RESET
    attendanceDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

    if (response["data"] == null || response["data"].isEmpty) {
      resetAttendanceUI();

      return;
    }

    todayAttendance = Attendance.fromJson(response["data"][0]);

    isLateCheckIn = todayAttendance?.isLate == 1;

    checkInTime = todayAttendance?.inTime ?? "--:--";

    checkOutTime = todayAttendance?.outTime ?? "--:--";

    totalHours = todayAttendance?.totalHours ?? "--:--";

    isCheckedIn = checkInTime != "00:00:00" && checkInTime.isNotEmpty;

    isCheckedOut = checkOutTime != "00:00:00" && checkOutTime.isNotEmpty;

    _updateLiveTotalHours();

    update();
  }

  void resetAttendanceUI() {
    attendanceDate = "";

    todayAttendance = null;

    isCheckedIn = false;

    isCheckedOut = false;

    isLateCheckIn = false;

    checkInTime = "--:--";

    checkOutTime = "--:--";

    totalHours = "--:--";

    _updateLiveTotalHours();

    update();
  }

  void validateAttendanceDay() {
    final today = DateFormat("yyyy-MM-dd").format(DateTime.now());

    if (attendanceDate.isEmpty) {
      return;
    }

    if (attendanceDate != today) {
      resetAttendanceUI();

      AppUtils.printMessage("Attendance UI Reset - New Day");
    }
  }

  Color get attendanceColor {
    if (!isCheckedIn) {
      return AppColor.kPrimaryColor;
    }

    return isLateCheckIn ? AppColor.kCheckOutRed_1 : AppColor.kCheckOutGreen_1;
  }

  List<Color> get attendanceGradient {
    if (!isCheckedIn) {
      return [AppColor.kButtonLinearColor_1, AppColor.kButtonLinearColor_2];
    }

    return isLateCheckIn
        ? [AppColor.kCheckOutRed_1, AppColor.kCheckOutRed_2]
        : [AppColor.kCheckOutGreen_1, AppColor.kCheckOutGreen_2];
  }

  String get attendanceButtonText {
    if (!isCheckedIn) {
      return "Check-in";
    }

    if (!isCheckedOut) {
      return "Check-out";
    }

    return "Check-out";
  }

  /// START LOCATION LISTENER
  Future<void> startLocationListener({bool requestPermission = true}) async {
    try {
      await positionStream?.cancel();
      if (isClosed) return;

      final access = await LocationService.checkAccess(
        requestPermission: requestPermission,
        requirePrecise: isOfficeEmployee,
      );
      if (isClosed) return;
      if (access != LocationAccessStatus.granted) {
        _locationUnavailable(access.message, settingsTarget: access);
        return;
      }

      if (locationSettingsTarget != null) {
        locationSettingsTarget = null;
        lastOfficeLocationStatus = null;
        officeDistance = "Getting location…";
        update();
      }

      positionStream = LocationService.getPositionStream().listen(
        (position) {
          if (currentPosition?.timestamp.isAfter(position.timestamp) ?? false) {
            return;
          }
          currentPosition = position;
          _updateCurrentLocationState();
          unawaited(_updateDisplayedAddress(position));
        },
        onError: (_) {
          _locationUnavailable("Unable to fetch location. Try again.");
        },
      );
    } catch (_) {
      _locationUnavailable("Unable to fetch location. Try again.");
    }
  }

  void _locationUnavailable(
    String message, {
    LocationAccessStatus? settingsTarget,
  }) {
    if (isClosed) return;
    locationSettingsTarget = settingsTarget;
    lastOfficeLocationStatus = null;
    currentPosition = null;
    currentAddress = "";
    isInsideOfficeRadius = false;
    canClockIn = false;
    officeDistance = message;
    update();
  }

  Future<void> openAttendanceLocationSettings() async {
    final target = locationSettingsTarget;
    if (target == null || _refreshLocationAfterSettings) return;
    _refreshLocationAfterSettings = true;
    try {
      if (await target.openSettings()) return;
    } catch (_) {
      // Some devices do not expose a settings screen to apps.
    }
    _refreshLocationAfterSettings = false;
    if (!isClosed) {
      Toast.error(message: "Couldn’t open Settings. ${target.message}");
    }
  }

  Future<Position?> _verifyOfficePosition() async {
    const uncertainMessage = "We couldn’t verify your location accurately. "
        "Enable Precise Location and try again.";
    final access = await LocationService.checkAccess(requirePrecise: true);
    if (isClosed) return null;
    if (access != LocationAccessStatus.granted) {
      _locationUnavailable(access.message, settingsTarget: access);
      Toast.error(message: access.message);
      return null;
    }

    locationSettingsTarget = null;
    officeDistance = "Verifying office location…";
    isVerifyingOfficeLocation = true;
    update();
    final Position? position;
    try {
      position = await LocationService.getAttendancePosition(
        isUsable: (position) =>
            _assessOfficePosition(position) != OfficeLocationStatus.uncertain,
      );
    } catch (_) {
      _locationUnavailable("Unable to verify your location. Try again.");
      rethrow;
    } finally {
      isVerifyingOfficeLocation = false;
      if (!isClosed) update();
    }
    if (isClosed) return null;
    if (position == null) {
      _locationUnavailable(uncertainMessage);
      Toast.error(message: uncertainMessage);
      return null;
    }

    currentPosition = position;
    final status = _assessOfficePosition(position);
    AppUtils.printMessage(
      "Office location: distance ${_distanceFromOffice(position).toStringAsFixed(0)} m, "
      "reported accuracy ${position.accuracy} m, "
      "fix age ${DateTime.now().difference(position.timestamp).inSeconds} s, "
      "${status.name}",
    );
    _updateCurrentLocationState();
    if (status == OfficeLocationStatus.inside) return position;

    final failure = status == OfficeLocationStatus.outside
        ? "You’re outside the office area. "
              "Move within ${officeRadius.round()} m and try again."
        : uncertainMessage;
    Toast.error(message: failure);
    return null;
  }

  Future<String> _addressFor(Position? position) async {
    if (position == null) return "";
    return LocationService.getAddressFromLatLng(
      latitude: position.latitude,
      longitude: position.longitude,
    ).timeout(const Duration(seconds: 2), onTimeout: () => "Location unavailable");
  }

  Future<void> _updateDisplayedAddress(Position position) async {
    final address = await _addressFor(position);
    if (isClosed || !identical(currentPosition, position)) return;
    currentAddress = address;
    update();
  }

  /// CREATE ATTENDANCE

  Future<void> createAttendance() async {
    if (isOpeningCamera) {
      return;
    }

    isOpeningCamera = true;
    var showingLoader = false;
    try {
      final user = currentUser?.data.firstOrNull;
      if (user == null) {
        Toast.error(message: "User information is loading. Please try again.");
        return;
      }

      final requiresOfficeLocation = isOfficeEmployee;
      final cameraPosition = requiresOfficeLocation
          ? await _verifyOfficePosition()
          : currentPosition;
      if (isClosed || (requiresOfficeLocation && cameraPosition == null)) return;

      /// CHECK-OUT CONFIRMATION
      if (shouldShowCheckoutConfirmation) {
        final bool confirm = await CommonConfirmationDialog.show(
          title: "Attendance",
          message: attendanceConfirmationMessage,
          description:
          "You have completed "
              "${totalHours == '00:00' ? getWorkedHours() : totalHours} "
              "for the day.",
          positiveText: isCheckedOut ? "Update" : "Check-out",
          positiveColor: AppColor.kCheckOutRed_1,
        );

        if (!confirm) {
          return;
        }
      }

      if (isClosed) return;
      final cameraAddress = await _addressFor(cameraPosition);
      if (isClosed) return;
      if (identical(currentPosition, cameraPosition)) {
        currentAddress = cameraAddress;
      }
      final image = await Get.to<File>(
        () => AttendanceCameraScreen(address: cameraAddress),
      );
      if (image == null || isClosed) return;

      final attendancePosition = requiresOfficeLocation
          ? await _verifyOfficePosition()
          : currentPosition;
      if (isClosed || (requiresOfficeLocation && attendancePosition == null)) {
        return;
      }
      final attendanceAddress = identical(cameraPosition, attendancePosition)
          ? cameraAddress
          : await _addressFor(attendancePosition);
      if (isClosed) return;
      if (identical(currentPosition, attendancePosition)) {
        currentAddress = attendanceAddress;
      }

      Loader.showLoader();
      showingLoader = true;

      final deviceInfo = await DeviceInfoService.getDeviceData();

      final Map<String, String> body = {
        "email": user.email,
        "current_address": attendanceAddress,
        "latitude": "${attendancePosition?.latitude ?? ""}",
        "longitude": "${attendancePosition?.longitude ?? ""}",
        "device_os": deviceInfo["device_os"] ?? "",
        "device_name": deviceInfo["device_name"] ?? "",
        "ip_address": "",
      };

      final response = await homeRepository.createAttendance(body, image);

      Loader.hideLoader();
      showingLoader = false;
      if (isClosed) return;

      updateAttendanceUI(response);

      if (response["data"] != null && response["data"].isNotEmpty) {
        final data = response["data"][0];

        if (data["out_time"] == "00:00:00") {
          CommonAttendancePopup.show(
            isLate: data["is_late"] == 1,
            time: data["in_time"],
          );
        }
      }

      Toast.success(
        message: response["message"] ?? "Attendance marked successfully",
      );
    } catch (e) {
      if (showingLoader) Loader.hideLoader();
      if (!isClosed) {
        Toast.error(message: showingLoader
            ? e.toString()
            : "Unable to verify attendance right now. Please try again.");
      }
    } finally {
      isOpeningCamera = false;
    }
  }

  void _updateEmployeeWorkLocation() {
    if (currentUser == null || currentUser!.data.isEmpty) {
      isUserLoaded = false;
      _isOfficeEmployee = false;

      return;
    }

    isUserLoaded = true;

    final workLocation =
        currentUser!.data.first.workLocation.trim().toLowerCase();

    _isOfficeEmployee = workLocation == "office";

    AppUtils.printMessage(
      "Employee Work Location : $workLocation",
    );

    AppUtils.printMessage(
      "Is Office Employee : $_isOfficeEmployee",
    );
  }

  OfficeLocationStatus _assessOfficePosition(Position position) {
    if (!LocationService.isRecentAttendanceFix(position, DateTime.now())) {
      return OfficeLocationStatus.uncertain;
    }
    return assessOfficeLocation(
      distance: _distanceFromOffice(position),
      horizontalAccuracy: position.accuracy,
      radius: officeRadius,
    );
  }

  double _distanceFromOffice(Position position) =>
      LocationService.calculateDistance(
        startLatitude: position.latitude,
        startLongitude: position.longitude,
        endLatitude: officeLat,
        endLongitude: officeLng,
      );

  void _updateCurrentLocationState() {
    if (isClosed || locationSettingsTarget != null) return;
    final position = currentPosition;
    final status = position == null
        ? OfficeLocationStatus.uncertain
        : _assessOfficePosition(position);
    lastOfficeLocationStatus = isOfficeEmployee ? status : null;
    isInsideOfficeRadius = isOfficeEmployee && status == OfficeLocationStatus.inside;
    canClockIn = isUserLoaded && (!isOfficeEmployee || isInsideOfficeRadius);

    if (!isUserLoaded) {
      officeDistance = "Checking work location…";
    } else if (!isOfficeEmployee) {
      officeDistance = "Remote working location";
    } else {
      officeDistance = switch (status) {
        OfficeLocationStatus.inside => "Within the office area",
        OfficeLocationStatus.outside => "Outside the office area",
        OfficeLocationStatus.uncertain => "Office location not verified",
      };
    }
    update();
  }

  /// GET USER
  /// GET USER  (returns false if the user was logged out as inactive)
  Future<bool> _getUser() async {
    bool inactive = false;

    try {
      Loader.showLoader();

      final value = await homeRepository.getUser();

      currentUser = CurrentUser.fromJson(value);

      if (_isUserInactive) {
        inactive = true;
      } else {
        /// SET WORK LOCATION IMMEDIATELY
        _updateEmployeeWorkLocation();

        await AppStorage.instance.setUserData(currentUser!);

        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().loadCurrentUser();
        }

        AppUtils.printMessage(
          "Get User - ${currentUser!.data.first.firstName}",
        );

        /// Recalculate location using current known position.
        _updateCurrentLocationState();

        update();

        /// Don't block HomeScreen for token API.
        unawaited(_postToken());
      }
    } catch (e) {
      Toast.error(message: e.toString());
    } finally {
      Loader.hideLoader();
    }

    /// Runs AFTER the loader is hidden, so the loader's Get.back()
    /// can't pop the login screen.
    if (inactive) {
      await _logoutInactiveUser();
      return false;
    }

    return true;
  }

  void _getTodaysAttendance() {
    Loader.showLoader();
    homeRepository.getTodaysAttendance().then(
          (value) {
        Loader.hideLoader();

        updateAttendanceUI(value);

        AppUtils.printMessage("getTodaysAttendance - $value");
      },
      onError: (e) {
        Loader.hideLoader();
        Toast.error(message: e);
      },
    );
  }
  Future<void> _logoutInactiveUser() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    AppStorage.instance.clearAll();

    Get.offAll(() => AuthScreen(), binding: AuthBinding());

    Toast.error(message: "Your account is inactive. Please contact Admin. ");
  }

  String getWorkedHours() {
    if (!isCheckedIn) {
      return "0 hours";
    }

    try {
      final now = DateTime.now();

      final inParts = checkInTime.split(":");

      final checkInDate = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(inParts[0]),
        int.parse(inParts[1]),
        int.parse(inParts[2]),
      );

      final diff = now.difference(checkInDate);

      final hours = diff.inHours;

      final minutes = diff.inMinutes % 60;

      return "$hours hours $minutes minutes";
    } catch (e) {
      return totalHours;
    }
  }

  /// POST TOKEN
  Future<void> _postToken() async {
    /// DEVICE INFO
    final deviceInfo = await DeviceInfoService.getDeviceData();

    var userId = currentUser!.data.first.userid;
    Map<String, String> body = {
      "userid": "$userId",
      "device_token": AppStorage.instance.valueFor(StorageKey.firebaseToken),
      "device_os": deviceInfo["device_os"],
      "device_name": deviceInfo["device_name"],
      "os_version": deviceInfo["os_version"],
    };

    //Loader.showLoader();
    homeRepository
        .postToken(body)
        .then(
          (value) {
        //Loader.hideLoader();
        AppUtils.printMessage("Token sent");
      },
      onError: (e) {
        Loader.hideLoader();
        Toast.error(message: e);
      },
    );
  }

  @override
  void onClose() {
    _locationLifecycleListener.dispose();
    timer?.cancel();

    positionStream?.cancel();

    buttonPressController.dispose();

    pulseController.dispose();

    statsIconController.dispose();

    super.onClose();
  }
}
