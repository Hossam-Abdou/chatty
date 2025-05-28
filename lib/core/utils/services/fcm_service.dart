import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FCMService {

  static Future<String?> getDeviceToken() async {
    try {
      // Get the FCM token for the current device
      String? token = await FirebaseMessaging.instance.getToken();
      debugPrint('FCM Token: $token'); // Print the token for debugging
      return token;
    } catch (e) {
      debugPrint('Error retrieving FCM token: $e');
      return null;
    }
  }


  void fetchAndStoreToken() async {
    String? fcmToken = await FCMService.getDeviceToken();
    if (fcmToken != null) {
      // Save the token to Firestore or your backend
      saveDeviceTokenToFirestore(fcmToken);
    }
  }


  Future<void> saveDeviceTokenToFirestore(String token) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'fcmToken': token});

    debugPrint('FCM Token saved to Firestore');

  }


  void listenForTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint('New FCM Token: $newToken');
      saveDeviceTokenToFirestore(newToken); // Update the token in Firestore
    });
  }

  Future<void> saveDeviceToken(String userId) async {
    // Get the FCM token for the current device
    String? token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      // Save the token in Firestore under the user's document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'fcmToken': token});
    }
  }




}


