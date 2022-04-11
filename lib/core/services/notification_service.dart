import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// A service to manage notifications by initialising the notifications for
/// supported platforms.
/// 
/// The [init] method must be called to initialise [NotificationService].
class NotificationService {
  /// The [FlutterLocalNotificationsPlugin] instance.
  final FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Initialises [FlutterLocalNotificationsPlugin].
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

    // Listen to incoming FCM payloads to handle foreground notifications.
    FirebaseMessaging.onMessage.listen((message) async {
      debugPrint("Received");
      await showMessage(message, localNotifications);
    });

    // Handles notifications in the background.
    FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  }
}

/// Displays the notification.
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

/// The handler for background messages.
///
/// [FirebaseMessaging.onBackgroundMessage] handler must be a top-level function. 
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  debugPrint("received in background");
}
