import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../login/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  bool darkMode = false;

  bool notificationEnabled = true;

  Future<void> logout() async {
    await storage.deleteAll();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Widget profileTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: (iconColor ?? Colors.blue).withOpacity(.1),
          child: Icon(icon, color: iconColor ?? Colors.blue),
        ),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, color: Colors.white, size: 50),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "John Smith",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "Delivery Executive",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: const [
                            Text(
                              "25",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),

                            Text("Today's Deliveries"),
                          ],
                        ),

                        Column(
                          children: const [
                            Text(
                              "320",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),

                            Text("Total Deliveries"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            profileTile(
              icon: Icons.badge,
              title: "Employee ID",
              subtitle: "EMP1001",
            ),

            profileTile(
              icon: Icons.email,
              title: "Email",
              subtitle: "johnsmith@gmail.com",
            ),

            profileTile(
              icon: Icons.phone,
              title: "Phone",
              subtitle: "+91 9876543210",
            ),

            profileTile(
              icon: Icons.location_city,
              title: "Branch",
              subtitle: "Chennai",
            ),

            profileTile(
              icon: Icons.dark_mode,
              title: "Dark Mode",
              trailing: Switch(
                value: darkMode,
                onChanged: (value) {
                  setState(() {
                    darkMode = value;
                  });
                },
              ),
            ),

            profileTile(
              icon: Icons.notifications,
              title: "Notifications",
              trailing: Switch(
                value: notificationEnabled,
                onChanged: (value) {
                  setState(() {
                    notificationEnabled = value;
                  });
                },
              ),
            ),

            profileTile(
              icon: Icons.lock,
              title: "Change Password",
              onTap: () {},
            ),

            profileTile(
              icon: Icons.info,
              title: "About App",
              subtitle: "Version 1.0.0",
            ),

            profileTile(
              icon: Icons.logout,
              title: "Logout",
              iconColor: Colors.red,
              onTap: logout,
            ),
          ],
        ),
      ),
    );
  }
}
