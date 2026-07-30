import 'package:delivery_management/core/api/base_dio.dart';
import 'package:delivery_management/models/dashboard_model.dart';
import 'package:dio/dio.dart';

class DashboardService {
  /// GET /dashboard
  static Future<DashboardResponse> getDashboard() async {
    try {
      final response = await BaseDio.I().get('/dashboard');
      return DashboardResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_extractMessage(e, fallback: 'Failed to load dashboard'));
    }
  }

  static String _extractMessage(DioException e, {required String fallback}) {
    final data = e.response?.data;
    if (data is Map && data['message'] is String) {
      return data['message'] as String;
    }
    return fallback;
  }
}
