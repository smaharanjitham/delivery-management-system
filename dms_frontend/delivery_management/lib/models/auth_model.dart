import 'user_model.dart';

/// POST /auth/register — request body
class RegisterRequest {
  final String fullName;
  final String email;
  final String password;
  final String phone;
  final int roleId;

  RegisterRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.roleId,
  });

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'email': email,
    'password': password,
    'phone': phone,
    'role_id': roleId,
  };
}

/// POST /auth/register — response body
class RegisterResponse {
  final bool success;
  final String message;

  RegisterResponse({required this.success, required this.message});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

/// POST /auth/login — request body
class LoginRequest {
  final String email;
  final String password;
  final String? fcmToken;
  final String? deviceName;

  LoginRequest({
    required this.email,
    required this.password,
    this.fcmToken,
    this.deviceName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {"email": email, "password": password};

    if (deviceName != null && deviceName!.isNotEmpty) {
      data["device_name"] = deviceName;
    }

    if (fcmToken != null && fcmToken!.isNotEmpty) {
      data["fcm_token"] = fcmToken;
    }

    return data;
  }
}

/// POST /auth/login — response body
class LoginResponse {
  final bool success;
  final String message;
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  LoginResponse({
    required this.success,
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }
}
