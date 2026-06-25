/*
 * Created by Deepak Gupta on 16/12/25
 *  Copyright (c) 2025 . All rights reserved.
 */

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../firebase/notification_payload_handler.dart';

class NotificationService {
  NotificationService._internal();

  static final NotificationService _service = NotificationService._internal();

  static NotificationService get service => _service;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  ///Android
  final androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'tys_hrms',
    'TYS HRMS Notification', //Required for Android 8.0 or after
    channelDescription:
        "HRMS Notifications",
    //Required for Android 8.0 or after
    importance: Importance.max,
    priority: Priority.high,
    channelShowBadge: true,
    visibility: NotificationVisibility.public,
    autoCancel: true,
    playSound: true,
    enableVibration: true
  );

  ///iOS Permission Setting
  final DarwinInitializationSettings _initializationSettingsIOS =
      const DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        defaultPresentAlert: true,
      );

  final DarwinNotificationDetails _iOSPlatformChannelSpecifics =
      const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

  ///Android Permission Setting
  final AndroidInitializationSettings _initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  Future<bool?> init() async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: _initializationSettingsAndroid,
      iOS: _initializationSettingsIOS,
    );

    return await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: selectNotification,
    );
  }

  Future<bool> permission() async {
    bool? result;
    if (Platform.isAndroid) {
      result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    } else {
      result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
    return result ?? false;
  }

  void show({String title = '', String body = '', String? data}) async {
    try {
      final platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: _iOSPlatformChannelSpecifics,
      );
      await flutterLocalNotificationsPlugin.show(
        id: Random().nextInt(10000),
        title: title,
        body: body,
        notificationDetails: platformChannelSpecifics,
        payload: '$data',
      );
    } catch (_) {}
  }

  Future selectNotification(
      NotificationResponse response,
      ) async {

    print("========== NOTIFICATION TAP ==========");
    print(response.payload);

    if (response.payload != null) {
      handleActions(response.payload!);
    }
  }

  Future<void> handleActions(String payload) async {
    try {
      final Map<String, dynamic> map = jsonDecode(payload);

      print("========================");

      print("Notification Payload");

      print(map);

      print("========================");

      NotificationPayloadHandler.instance.handle(map);
    } catch (e) {
      print("Notification Parse Error => $e");
    }
  }
}
