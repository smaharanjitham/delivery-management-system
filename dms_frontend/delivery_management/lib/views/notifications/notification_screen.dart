import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> notifications = [
    {
      "title": "New Delivery Assigned",
      "message": "Order #1001 has been assigned to you.",
      "time": "2 min ago",
      "isRead": false,
      "icon": Icons.local_shipping,
      "color": Colors.blue,
    },
    {
      "title": "Delivery Completed",
      "message": "Order #1002 marked as Delivered.",
      "time": "10 min ago",
      "isRead": true,
      "icon": Icons.check_circle,
      "color": Colors.green,
    },
    {
      "title": "Delivery Delayed",
      "message": "Order #1003 is delayed due to traffic.",
      "time": "25 min ago",
      "isRead": false,
      "icon": Icons.warning,
      "color": Colors.orange,
    },
    {
      "title": "Order Cancelled",
      "message": "Order #1004 has been cancelled.",
      "time": "1 hour ago",
      "isRead": true,
      "icon": Icons.cancel,
      "color": Colors.red,
    },
  ];

  Future<void> refreshNotifications() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  void markAllAsRead() {
    setState(() {
      for (var item in notifications) {
        item["isRead"] = true;
      }
    });
  }

  void deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Mark all as read",
            onPressed: markAllAsRead,
            icon: const Icon(Icons.done_all),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 80, color: Colors.grey),
                  SizedBox(height: 15),
                  Text(
                    "No Notifications",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: refreshNotifications,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];

                  return Dismissible(
                    key: Key(index.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      deleteNotification(index);
                    },
                    child: Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: notification["color"].withOpacity(
                            .15,
                          ),
                          child: Icon(
                            notification["icon"],
                            color: notification["color"],
                          ),
                        ),
                        title: Text(
                          notification["title"],
                          style: TextStyle(
                            fontWeight: notification["isRead"]
                                ? FontWeight.normal
                                : FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(notification["message"]),
                            const SizedBox(height: 6),
                            Text(
                              notification["time"],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        trailing: notification["isRead"]
                            ? null
                            : Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                        onTap: () {
                          setState(() {
                            notification["isRead"] = true;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(notification["title"])),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
