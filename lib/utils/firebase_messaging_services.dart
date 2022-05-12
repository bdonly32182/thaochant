import 'package:chanthaburi_app/resources/auth_method.dart';
import 'package:chanthaburi_app/routes.dart';
import 'package:chanthaburi_app/utils/notification_services.dart';
import 'package:chanthaburi_app/utils/sharePreferrence/share_referrence.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingService {
  final NotificationServices _notificationService;

  FirebaseMessagingService(this._notificationService);

  Future<void> initialize() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
      alert: true,
    );
    getDeviceFirebaseToken();
    _onMessage();
    _onMessageOpenedApp();
  }

  getDeviceFirebaseToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    String userId = await ShareRefferrence.getUserId();
    if (token != null && userId.isNotEmpty) {
      String userId = await ShareRefferrence.getUserId();
      await AuthMethods.userUpdateToken(token, userId);
    }
  }

  _onMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? apple = message.notification!.apple;

      if (notification != null && android != null) {
        _notificationService.showLocalNotification(
          CustomNotification(
            id: android.hashCode,
            title: notification.title!,
            body: notification.body!,
            payload: '/home',
          ),
        );
      }
      if (notification != null && apple != null) {
        _notificationService.showLocalNotification(
          CustomNotification(
            id: android.hashCode,
            title: notification.title!,
            body: notification.body!,
            payload: '/home',
          ),
        );
      }
    });
  }

  _onMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen(_goToPageAfterMessage);
  }

  _goToPageAfterMessage(message) {
    Routes.navigatorKey?.currentState?.pushNamed('/home');
  }
}
