import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FcmTokenApiService {
  static String get baseUrl => dotenv.env["BASE_URL"]!;

  static Future<bool> saveToken({
    required int userId,
    required String fcmToken,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/fcm-token"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId, "fcm_token": fcmToken}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("FCM Token Saved");
        return true;
      } else {
        debugPrint("Failed : ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("FCM API Error : $e");
      return false;
    }
  }
}
