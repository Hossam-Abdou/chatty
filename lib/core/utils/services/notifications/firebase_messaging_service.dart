// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
//
// import 'push_token_client.dart';
// //----------------------------------------------------------
//
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   debugPrint("Handling a background message");
// }
// Future<void> firebaseMessagingForegroundMessagedHandler(RemoteMessage message) async {
//   debugPrint("Handling a background message");
// }
// class FirebaseMessagingService {
//   final _instance = FirebaseMessaging.instance;
//
//   void registerNotificationsHandlers() async {
//     _instance.requestPermission();
//     await _instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//     // FirebaseMessaging.onMessageOpenedApp.listen(_handleFcmChatNotification);
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint("onMessage: ${message.notification?.title}/${message.notification?.body}");
//       // }
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen(firebaseMessagingForegroundMessagedHandler);
//
//     // _instance.onTokenRefresh.listen(PushTokenClient().updateUserPushToken);
//   }
//
//   /// Handles initial message that opened the app from a terminated state.
//   // void handleInitialMessage() {
//   //   _instance.getInitialMessage().then((RemoteMessage? message) {
//   //     _handleFcmChatNotification(message);
//   //   });
//   // }
//
//   Future<String?> getDefaultPushToken() async {
//     String? devicePushToken = await _instance.getToken();
//     AppStrings.fcmPushToken = devicePushToken;
//     debugPrint(
//         "devicePushToken: $devicePushToken ----& fcmPushToken: ${AppStrings.fcmPushToken}");
//     return devicePushToken;
//   }
//
//
//   void invalidateDevicePushToken() {
//     _instance.deleteToken();
//   }
//
//
// }
//
// class AppStrings {
//   static String? fcmPushToken;
// }
