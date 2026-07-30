import 'package:delivery_management/models/dashboard_model.dart';
import 'package:delivery_management/services/dashboard_service.dart';
import 'package:delivery_management/views/map/map_screen.dart';
import 'package:delivery_management/views/notifications/notification_screen.dart';
import 'package:delivery_management/views/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../login/login_screen.dart';
import '../orders/order_details_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  int currentIndex = 0;

  bool isLoading = true;
  String? errorMessage;
  DashboardSummary summary = DashboardSummary(
    pending: 0,
    delivered: 0,
    today: 0,
    cancelled: 0,
  );
  List<RecentOrder> orders = [];

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await DashboardService.getDashboard();
      setState(() {
        summary = result.summary;
        orders = result.recentOrders;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceFirst('Exception: ', '');
        isLoading = false;
      });
    }
  }

  Future<void> logout() async {
    await storage.deleteAll();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'out for delivery':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  Widget buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(.1),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOrderCard(RecentOrder order) {
    final color = statusColor(order.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: const Icon(Icons.local_shipping, color: Colors.white),
        ),
        title: Text(
          order.customerName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order.orderNumber),
            Text(order.deliveryAddress),
            const SizedBox(height: 4),
            Chip(
              label: Text(
                order.status,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: color,
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrderDetailsScreen(
                  order: {
                    "id": order.orderNumber,
                    "customer": order.customerName,
                    "address": order.deliveryAddress,
                    "status": order.status,
                    "color": color,
                  },
                ),
              ),
            );

            if (result != null) {
              // Refresh from server after an edit rather than trusting local state
              loadDashboard();
            }
          },
        ),
      ),
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: loadDashboard,
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadDashboard,
      child: ListView(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Search Orders",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: const Icon(Icons.filter_list),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              buildSummaryCard(
                "Pending",
                "${summary.pending}",
                Icons.pending_actions,
                Colors.orange,
              ),
              const SizedBox(width: 10),
              buildSummaryCard(
                "Delivered",
                "${summary.delivered}",
                Icons.check_circle,
                Colors.green,
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              buildSummaryCard(
                "Today's",
                "${summary.today}",
                Icons.today,
                Colors.blue,
              ),
              const SizedBox(width: 10),
              buildSummaryCard(
                "Cancelled",
                "${summary.cancelled}",
                Icons.cancel,
                Colors.red,
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Recent Orders",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 10),

          if (orders.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: Text("No recent orders")),
            )
          else
            ...orders.map(buildOrderCard),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Delivery Executive"),
              accountEmail: Text("delivery@gmail.com"),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person, size: 40),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text("Map"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MapScreen(
                      customerName: "John Smith",
                      address: "Chennai",
                      latitude: 13.0827,
                      longitude: 80.2707,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notifications"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: logout,
            ),
          ],
        ),
      ),

      appBar: AppBar(
        title: const Text("Delivery Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: loadDashboard,
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(16), child: buildBody()),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });

          switch (index) {
            case 0:
              break;

            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MapScreen(
                    customerName: "John Smith",
                    address: "Chennai",
                    latitude: 13.0827,
                    longitude: 80.2707,
                  ),
                ),
              );
              break;

            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationScreen()),
              );
              break;

            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notification",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
