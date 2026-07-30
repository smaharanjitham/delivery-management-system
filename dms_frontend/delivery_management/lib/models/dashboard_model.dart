class DashboardSummary {
  final int pending;
  final int delivered;
  final int today;
  final int cancelled;

  DashboardSummary({
    required this.pending,
    required this.delivered,
    required this.today,
    required this.cancelled,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      pending: json['pending'] ?? 0,
      delivered: json['delivered'] ?? 0,
      today: json['today'] ?? 0,
      cancelled: json['cancelled'] ?? 0,
    );
  }
}

class RecentOrder {
  final int id;
  final String orderNumber;
  final String customerName;
  final String deliveryAddress;
  final double? deliveryLatitude;
  final double? deliveryLongitude;
  final String status;

  RecentOrder({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.deliveryAddress,
    this.deliveryLatitude,
    this.deliveryLongitude,
    required this.status,
  });

  factory RecentOrder.fromJson(Map<String, dynamic> json) {
    return RecentOrder(
      id: json['id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      customerName: json['customer_name'] ?? '',
      deliveryAddress: json['delivery_address'] ?? '',
      deliveryLatitude: (json['delivery_latitude'] as num?)?.toDouble(),
      deliveryLongitude: (json['delivery_longitude'] as num?)?.toDouble(),
      status: json['status'] ?? '',
    );
  }
}

class DashboardResponse {
  final bool success;
  final String message;
  final DashboardSummary summary;
  final List<RecentOrder> recentOrders;

  DashboardResponse({
    required this.success,
    required this.message,
    required this.summary,
    required this.recentOrders,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      summary: DashboardSummary.fromJson(json['summary'] ?? {}),
      recentOrders: (json['recentOrders'] as List<dynamic>? ?? [])
          .map((e) => RecentOrder.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
