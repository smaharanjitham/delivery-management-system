import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'views/splash/splash_screen.dart';
import 'views/login/login_screen.dart';
import 'views/dashboard/dashboard_screen.dart';

import 'providers/user_provider.dart';

import 'models/user_model.dart';

import 'services/push_notification_service.dart';
import 'services/fcm_token_api_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load Environment Variables
  await dotenv.load(fileName: ".env");

  // Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Push Notification
  await NotificationService.instance.initialize();

  runApp(const ProviderScope(child: MyApp()));
}

enum LaunchState { splash, login, dashboard }

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  Future<LaunchState> _checkLogin(WidgetRef ref) async {
    const storage = FlutterSecureStorage();

    final token = await storage.read(key: "accessToken");

    final id = await storage.read(key: "user_id");

    final name = await storage.read(key: "user_name");

    final email = await storage.read(key: "user_email");

    if (token == null || token.isEmpty) {
      return LaunchState.login;
    }

    ref.read(userProvider.notifier).state = UserModel(
      id: int.tryParse(id ?? "0") ?? 0,
      name: name ?? "",
      email: email ?? "",
    );

    //await _saveFcmToken();
    // Listen for FCM token changes
    NotificationService.instance.onTokenRefresh((newToken) async {
      final userId = await storage.read(key: "user_id");

      if (userId == null) return;

      await FcmTokenApiService.saveToken(
        userId: int.parse(userId),
        fcmToken: newToken,
      );
    });

    return LaunchState.dashboard;
  }

  // Future<void> _saveFcmToken() async {
  //   try {
  //     final token = await NotificationService.instance.getToken();

  //     if (token == null) return;

  //     const storage = FlutterSecureStorage();

  //     final userId = await storage.read(key: "user_id");

  //     if (userId == null) return;

  //     await FcmTokenApiService.saveToken(
  //       userId: int.parse(userId),
  //       fcmToken: token,
  //     );

  //     NotificationService.instance.onTokenRefresh((newToken) async {
  //       await FcmTokenApiService.saveToken(
  //         userId: int.parse(userId),
  //         fcmToken: newToken,
  //       );
  //     });
  //   } catch (e) {
  //     debugPrint("FCM Error : $e");
  //   }
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      navigatorKey: navigatorKey,

      debugShowCheckedModeBanner: false,

      title: "Delivery Management",

      themeMode: ThemeMode.system,

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),

      home: FutureBuilder<LaunchState>(
        future: _checkLogin(ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          switch (snapshot.data) {
            case LaunchState.login:
              return const LoginScreen();

            case LaunchState.dashboard:
              return const DashboardScreen();

            default:
              return const LoginScreen();
          }
        },
      ),
    );
  }
}
