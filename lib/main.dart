import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

// import 'firebase_options.dart';
import 'screens/auth/login.dart';
import 'screens/home.dart';
import 'utils/constants.dart';
import 'utils/notifications.dart';
import 'utils/primary_provider.dart';
import 'utils/theme.dart';

Future<void> backgroundHandler(RemoteMessage message) async {}

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // initialize();
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null && message.data['route'] != null) {}
    });

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        // display(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.data['route'] != null) {}
    });
  }

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PrimaryProvider()),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: appName,
          theme: lightTheme,
          themeMode: ThemeMode.light,
          home: const SplashScreen(),
        ),
      );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> check() async {
    Widget widget = const SizedBox();
    final pp = Provider.of<PrimaryProvider>(context, listen: false);
    await pp.updatePackageInfo();
    await pp.updateCustomerId();
    debugPrint('v ${pp.version + pp.buildNumber}');
    if (pp.isUserLogin) {
      widget = const Home();
    } else {
      widget = const Login();
    }

    if (mounted) {
      FlutterNativeSplash.remove();
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget),
      );
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: check(),
        builder: (context, snapshot) => const SizedBox(),
      );
}
