import 'package:chanthaburi_app/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class CustomNotification {
  final int id;
  final String title;
  final String body;
  final String? payload;
  final RemoteMessage? remoteMessage;
  CustomNotification({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    this.remoteMessage,
  });
}

class NotificationServices {
  // 1.
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;

  // 2.
  NotificationServices() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupAndroidDetails();
    _setupNotifications();
  }

  // 3.
  _setupAndroidDetails() {
    androidDetails = const AndroidNotificationDetails(
      'thaochan_notification_x',
      'thaochan',
      channelDescription: 'welcome to thaochan',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    );
  }

  _setupNotifications() async {
    await _setupTimezone();
    await _initializeNotifications();
  }

  // 4.
  Future<void> _setupTimezone() async {
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  _initializeNotifications() async {
    AndroidInitializationSettings android =
        const AndroidInitializationSettings('app_icon');
    IOSInitializationSettings ios = const IOSInitializationSettings();
    // Fazer: macOs, iOS, Linux...
    await localNotificationsPlugin.initialize(
      InitializationSettings(android: android, iOS: ios),
      onSelectNotification: _onSelectNotification,
    );
  }

  // 5.
  _onSelectNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      Navigator.of(Routes.navigatorKey!.currentContext!).pushNamed(payload);
    } else {
      if (Routes.navigatorKey != null &&
          Routes.navigatorKey!.currentContext != null) {
        Navigator.of(Routes.navigatorKey!.currentContext!).pushNamed('/home');
      }
    }
  }

  // 6.
  showLocalNotification(CustomNotification notification) {
    IOSNotificationDetails iosNotificationDetails =
        const IOSNotificationDetails();
    localNotificationsPlugin.show(
      notification.id,
      notification.title,
      notification.body,
      NotificationDetails(android: androidDetails, iOS: iosNotificationDetails),
      payload: notification.payload,
    );
  }

  checkForNotifications() async {
    final details =
        await localNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      _onSelectNotification(details.payload);
    }
  }
}
