import 'package:delivery_management/core/api/base_dio.dart';
import 'package:delivery_management/models/auth_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();

  /// POST /auth/register
  static Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await BaseDio.I().post(
        '/auth/register',
        data: request.toJson(),
      );

      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_extractMessage(e, fallback: 'Registration failed'));
    }
  }

  /// POST /auth/login
  static Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await BaseDio.I().post(
        '/auth/login',
        data: request.toJson(),
      );

      final loginResponse = LoginResponse.fromJson(response.data);
      await _persistSession(loginResponse);

      return loginResponse;
    } on DioException catch (e) {
      throw Exception(_extractMessage(e, fallback: 'Invalid credentials'));
    }
  }

  static Future<void> logout() async {
    await BaseDio.clearStorage();
  }

  static Future<void> _persistSession(LoginResponse loginResponse) async {
    await _storage.write(key: 'accessToken', value: loginResponse.accessToken);
    await _storage.write(
      key: 'refreshToken',
      value: loginResponse.refreshToken,
    );
    await _storage.write(
      key: 'user_id',
      value: loginResponse.user.id.toString(),
    );
    await _storage.write(key: 'user_name', value: loginResponse.user.name);
    await _storage.write(key: 'user_email', value: loginResponse.user.email);
  }

  static String _extractMessage(DioException e, {required String fallback}) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return fallback;
  }
}
