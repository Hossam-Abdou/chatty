// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class PushNotificationManager {
//   static final _firebaseMessaging = FirebaseMessaging.instance;
//
//   static Future<void> initialize(
//       FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//     await _firebaseMessaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//
//     const AndroidInitializationSettings androidInitializationSettings =
//     AndroidInitializationSettings('@mipmap/app_icon');
//
//     const DarwinInitializationSettings iosInitializationSettings =
//     DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//
//     const InitializationSettings initializationSettings =
//     InitializationSettings(
//       android: androidInitializationSettings,
//       iOS: iosInitializationSettings,
//     );
//
//     flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse:
//           (NotificationResponse notificationResponse) {
//         // final String? payload = notificationResponse.payload;
//         if (notificationResponse.payload != null) {
//           debugPrint("hihi");
//           // log('notification payload: $payload');
//         }
//       },
//     );
//
//     FirebaseMessaging.onMessage.listen((message) {
//       debugPrint(
//           '================================ FOREGROUND NOTIFICATION ================================');
//       debugPrint('Notification title: ${message.notification?.title}');
//       debugPrint('Notification body: ${message.notification?.body}');
//       showNotification(message: message, fln: flutterLocalNotificationsPlugin);
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       if (message.notification?.body != null) {}
//       debugPrint(
//           '================================ NOTIFICATION OPENED FROM BACKGROUND ================================');
//       debugPrint('Notification title: ${message.notification?.title}');
//       debugPrint('Notification body: ${message.notification?.body}');
//       showNotification(message: message, fln: flutterLocalNotificationsPlugin);
//     });
//   }
//
//   static Future<void> showNotification({
//     required RemoteMessage message,
//     required FlutterLocalNotificationsPlugin fln,
//     String? payload,
//   }) async {
//     await _firebaseMessaging.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails(
//       'high_channel',
//       'High Importance Notification',
//       channelDescription: 'This channel is for important notification',
//       importance: Importance.max,
//       priority: Priority.high,
//       enableLights: true,
//       enableVibration: true,
//       ticker: 'ticker',
//       icon: '@mipmap/ic_launcher', // Ensure this icon exists in your resources
//     );
//
//     const DarwinNotificationDetails darwinNotificationDetails =
//     DarwinNotificationDetails(
//       presentSound: true,
//       presentBadge: true,
//       presentAlert: true,
//     );
//
//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//       iOS: darwinNotificationDetails,
//     );
//
//     await fln.show(
//       0,
//       message.notification?.title,
//       message.notification?.body,
//       notificationDetails,
//       payload: payload,
//     );
//   }
// }
