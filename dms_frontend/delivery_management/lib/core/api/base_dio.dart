import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:delivery_management/main.dart';
import 'package:delivery_management/views/login/login_screen.dart';

class BaseDio {
  static Dio? _instance;
  static const _storage = FlutterSecureStorage();

  static Dio I() {
    if (_instance != null) return _instance!;

    final baseUrl = dotenv.env['VITE_API_BASE_URL'] ?? '';

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'accessToken');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (DioException e, handler) async {
          final statusCode = e.response?.statusCode;
          final path = e.requestOptions.path;
          final isAuthRequest =
              path.contains('login') || path.contains('register');

          if (statusCode == 401 && !isAuthRequest) {
            await _handleLogout();
          }
          handler.next(e);
        },
      ),
    );

    _instance = dio;
    return _instance!;
  }

  // Public — called by both the interceptor logout and a manual logout button
  static Future<void> clearStorage() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'user_name');
    await _storage.delete(key: 'user_email');
  }
}

Future<void> _handleLogout() async {
  await BaseDio.clearStorage();

  navigatorKey.currentState?.pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const LoginScreen()),
    (_) => false,
  );
}
