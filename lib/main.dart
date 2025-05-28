import 'package:chatty/core/utils/services/fcm_service.dart';
import 'package:chatty/src/app_root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'core/utils/services/secure_storage.dart'; // Assuming this is your secure storage service
import 'firebase_options.dart'; // Firebase configuration
import 'bloc_observer.dart'; // Custom BlocObserver

// Initialize FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Background message handler for FCM
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint("Handling a background message: ${message.messageId}");
}

// Function to display local notifications
void showLocalNotification(RemoteMessage message) async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/notification');
  const DarwinInitializationSettings iosInitializationSettings =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: iosInitializationSettings);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel', // Channel ID
          'High Importance Notifications', // Channel name
          importance: Importance.max,
          priority: Priority.high,
          icon: '@drawable/notification',
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize Secure Storage
  await SecureStorage.init();

  String? token = await SecureStorage.getData(key: 'token');
  debugPrint('Route $token');
  // Initialize Firebase Messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request notification permissions
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  debugPrint('User granted permission: ${settings.authorizationStatus}');

  // Handle background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint(
        "Notification received in foreground: ${message.notification?.title}");
    showLocalNotification(message);
  });

  // Handle app opened from a notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint("App opened from a notification: ${message.data}");
    // Navigate to specific screens or perform actions based on the notification data
  });

  // Fetch and store the FCM token
  FCMService().fetchAndStoreToken();

  // Listen for token refresh events
  FCMService().listenForTokenRefresh();

  // Set up custom BlocObserver
  Bloc.observer = MyBlocObserver();

  // Run the app
  runApp(AppRoot(
    loggedIn: token == null ? false : true,
  ));
}
