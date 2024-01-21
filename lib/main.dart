import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grit_qr_scanner/features/auth/screens/login_screen.dart';
import 'package:grit_qr_scanner/features/auth/services/user_service.dart';
import 'package:grit_qr_scanner/features/home/screens/home_screen.dart';
import 'package:grit_qr_scanner/features/home/screens/splash_screen.dart';
import 'package:grit_qr_scanner/provider/order_provider.dart';
import 'package:grit_qr_scanner/provider/product_provider.dart';
import 'package:grit_qr_scanner/provider/user_provider.dart';
import 'package:grit_qr_scanner/routers.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:provider/provider.dart';

Future main() async {
  await dotenv.load(fileName: "apikeys.env");
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<UserProvider>.value(
      value: UserProvider(),
    ),
    ChangeNotifierProvider(create: (context) => ProductProvider()),
    ChangeNotifierProvider(create: (context) => OrderProvider()),
  ], child: const MyApp()));
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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Grit QR Scanner',
      scaffoldMessengerKey: snackbarKey,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: FutureBuilder(
        future: UserService().validateSession(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen(); //return splash screen
          } else {
            return snapshot.data! ? const HomeScreen() : const LoginScreen();
          }
        },
      ),
    );
  }
}
