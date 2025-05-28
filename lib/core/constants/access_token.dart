import 'dart:convert';

import 'package:chatty/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

 abstract class AppAccessToken{

 static  Future<String> getAccessToken() async {
    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(AppConstants.serviceAccount);

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final client = await clientViaServiceAccount(serviceAccountCredentials, scopes);
    return client.credentials.accessToken.data;
  }

 static Future<void> sendNotificationToDevice(String fcmToken, String messageText,String sender) async {
    const String fcmEndpoint = 'https://fcm.googleapis.com/v1/projects/${AppConstants.projectID}/messages:send';

    try {
      // Dynamically fetch the OAuth 2.0 access token
      final String accessToken = await getAccessToken();
      debugPrint('Generated OAuth 2.0 Access Token: $accessToken');

      // Construct the notification payload
      final Map<String, dynamic> message = {
        'notification': {
          "title": sender,
          "body": messageText,
        },
        'token': fcmToken,

      };

      final Map<String, dynamic> requestBody = {
        "message": message,
      };

      // Send the notification
      final response = await http.post(
        Uri.parse(fcmEndpoint),
        headers: <String, String>{
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(requestBody),
      );

      // Handle the response
      if (response.statusCode == 200) {
        debugPrint('Notification sent successfully!');
      } else {
        debugPrint('Failed to send notification. Status code: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error sending notification: $e');
    }
  }
}