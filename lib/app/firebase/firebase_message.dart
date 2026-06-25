/*
 * Created by Deepak Gupta on 16/12/2025
 *  Copyright (c) 2025 . All rights reserved.
 */

import 'dart:convert';
import 'dart:developer' as NotificationLogger;
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../core/utils/app_storage.dart';
import '../services/notification_service.dart';
import 'notification_payload_handler.dart';

class AppFirebaseMessage {
  AppFirebaseMessage._();

  static final AppFirebaseMessage _instance = AppFirebaseMessage._();

  static AppFirebaseMessage get instance => _instance;

  // Future<void> permission() async {
  //   return await FirebaseMessaging.instance
  //       .requestPermission(alert: true, sound: true, badge: true)
  //       .then((value) {
  //         token();
  //       });
  // }

  Future<void> permission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );


    token();
  }

  Future<void> token() async {
    //This will give us the FCM token
    try {
      FirebaseMessaging.instance.getToken().then((value) {
        AppStorage.instance.setValue(StorageKey.firebaseToken, value);
        debugPrint("🔐️Token Generated: $value");
      });

      //This will give us the FCM token after
      //deleting the token.
      FirebaseMessaging.instance.onTokenRefresh.listen((event) {
        AppStorage.instance.setValue(StorageKey.firebaseToken, event);
        debugPrint("🔐️Token Refreshed: $event");
      });
    } catch (e) {
      debugPrint("‼️Something wrong with firebase $e");
    }
  }

  Future<void> receiveMessage() async {
    await FirebaseMessaging.instance.subscribeToTopic('announcement');

    //To listen to messages whilst your application is in the foreground, listen to the onMessage stream.
    FirebaseMessaging.onMessage.listen((event) {

      NotificationLogger.log(
        "Foreground => ${event.data}",
      );

      // print(event.data);
      // print(event.data['title']);
      // print(event.data['body']);

      NotificationService.service.show(
        title: event.data['title'] ?? '',
        body: event.data['body'] ?? '',
        data: jsonEncode(event.data),
      );
    });

    //When the application is open, however in the background (minimised). This
    // typically occurs when the user has pressed the "home" button on the device,
    // has switched to another app via the app switcher or has
    // the application open on a different tab (web).
    FirebaseMessaging.onMessageOpenedApp.listen((event) {

      NotificationLogger.log(
        "Opened App => ${event.data}",
      );

      NotificationPayloadHandler.instance.handle(
        event.data,
      );

    });

    //When the device is locked or the application is not running. The user can
    // terminate an app by "swiping it away" via the app switcher
    // UI on the device or closing a tab (web).
    FirebaseMessaging.instance.getInitialMessage().then((value) async {
      final message = await FirebaseMessaging.instance.getInitialMessage();

      if (message != null) {
        NotificationLogger.log("Initial Message => ${message.data}");

        NotificationPayloadHandler.instance.handle(message.data);
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> tokenRefresh() async {
    try {
      FirebaseMessaging.instance.deleteToken().then((value) {
        token();
      });
    } catch (e) {
      debugPrint('error $e');
    }
  }

  Future<void> testNotification() async {

    NotificationService.service.show(
      title: "Test Notification",
      body: "Local notification working",
      data: jsonEncode({
        "label": "GN",
      }),
    );
  }

}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("FCM PAYLOAD  => $message");
}
