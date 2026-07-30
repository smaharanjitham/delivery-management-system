import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    if (kIsWeb) {
      debugPrint("Skipping Firebase Messaging on Web");
      return;
    }

    await _messaging.requestPermission();

    FirebaseMessaging.onMessage.listen((message) {
      debugPrint(message.notification?.title);
    });
  }

  Future<String?> getToken() async {
    if (kIsWeb) {
      return null;
    }

    return await _messaging.getToken();
  }

  void onTokenRefresh(Function(String token) callback) {
    if (kIsWeb) return;

    FirebaseMessaging.instance.onTokenRefresh.listen(callback);
  }
}
