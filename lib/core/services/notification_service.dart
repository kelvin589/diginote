import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    await localNotifications.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((message) async {
      debugPrint("Received");
      await showMessage(message, localNotifications);
    });

    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  }
}

Future<void> showMessage(RemoteMessage message,
    FlutterLocalNotificationsPlugin localNotifications) async {
  const AndroidNotificationDetails notificationDetailsAndroid =
      AndroidNotificationDetails(
    'DiginoteNotificationID',
    'Diginote Notification',
    channelDescription: 'A diginote notification',
    importance: Importance.max,
    priority: Priority.high,
  );
  const NotificationDetails notificationDetails =
      NotificationDetails(android: notificationDetailsAndroid);
  await localNotifications.show(
    message.notification.hashCode,
    message.notification!.title,
    message.notification!.body,
    notificationDetails,
  );
}

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  debugPrint("received in background");
}
