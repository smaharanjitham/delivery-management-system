import 'package:flutter/material.dart';

import 'package:delivery_management/core/theme/app_colors.dart';

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
      "color": AppColors.info,
    },
    {
      "title": "Delivery Completed",
      "message": "Order #1002 marked as Delivered.",
      "time": "10 min ago",
      "isRead": true,
      "icon": Icons.check_circle,
      "color": AppColors.success,
    },
    {
      "title": "Delivery Delayed",
      "message": "Order #1003 is delayed due to traffic.",
      "time": "25 min ago",
      "isRead": false,
      "icon": Icons.warning,
      "color": AppColors.warning,
    },
    {
      "title": "Order Cancelled",
      "message": "Order #1004 has been cancelled.",
      "time": "1 hour ago",
      "isRead": true,
      "icon": Icons.cancel,
      "color": AppColors.danger,
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        actions: [
          IconButton(
            tooltip: "Mark all as read",
            onPressed: markAllAsRead,
            icon: const Icon(Icons.done_all, color: Colors.white),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 80,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "No Notifications",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              color: AppColors.primary,
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
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      deleteNotification(index);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
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
                            color: AppColors.textPrimary,
                            fontWeight: notification["isRead"]
                                ? FontWeight.normal
                                : FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              notification["message"],
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              notification["time"],
                              style: const TextStyle(
                                color: AppColors.textSecondary,
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
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                        onTap: () {
                          setState(() {
                            notification["isRead"] = true;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(notification["title"]),
                            ),
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
