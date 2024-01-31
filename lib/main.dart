import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grit_qr_scanner/features/auth/screens/login_screen.dart';
import 'package:grit_qr_scanner/features/auth/services/user_service.dart';
import 'package:grit_qr_scanner/features/home/screens/home_screen.dart';
import 'package:grit_qr_scanner/features/home/screens/splash_screen.dart';
import 'package:grit_qr_scanner/provider/language_provider.dart';
import 'package:grit_qr_scanner/provider/order_provider.dart';
import 'package:grit_qr_scanner/provider/product_provider.dart';
import 'package:grit_qr_scanner/provider/sales_provider.dart';
import 'package:grit_qr_scanner/provider/user_provider.dart';
import 'package:grit_qr_scanner/routers.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:grit_qr_scanner/utils/widgets/error_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await dotenv.load(fileName: "apikeys.env");
  SharedPreferences preferences = await SharedPreferences.getInstance();
  final String languageCode = preferences.getString("language_code") ?? "";

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>.value(
          value: UserProvider(),
        ),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider.value(value: LanguageChangeProvider()),
        ChangeNotifierProvider(create: (context) => SalesProvider()),
      ],
      child: MyApp(
        languageCode: languageCode,
      )));
}

class MyApp extends StatefulWidget {
  final String languageCode;
  const MyApp({super.key, required this.languageCode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageChangeProvider>(
      builder: (_, provider, child) {
        if (widget.languageCode.isEmpty) {
          provider.changeLangauge(const Locale('ne'));
        }
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Grit QR Scanner',
            scaffoldMessengerKey: snackbarKey,
            navigatorKey: navigatorKey,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              fontFamily: 'Poppins',
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                  backgroundColor: blueColor,
                  iconTheme: IconThemeData(
                    color:
                        Colors.white, // Set the color of the back button here
                  ),
                  actionsIconTheme: IconThemeData(color: Colors.white),
                  titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: "Poppins")),
            ),

            // ignore: prefer_if_null_operators
            locale: provider.appLocale == null
                ? const Locale('ne')
                : provider.appLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'), // English
              Locale('ne', 'NP'), // Nepali
            ],
            onGenerateRoute: (settings) => generateRoute(settings),
            home: FutureBuilder(
              future: _userService.validateSession(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  debugPrint("watiig");
                  if (snapshot.hasData) debugPrint(snapshot.data!.toString());
                  return const SplashScreen(); // return splash screen
                } else if (snapshot.hasData) {
                  debugPrint(snapshot.data!.toString());
                  return snapshot.data!
                      ? const HomeScreen()
                      : const LoginScreen();
                } else {
                  return const ErrorPage(
                    message: "Something went wrong",
                  ); // Handle the case when data is not available
                }
              },
            ));
      },
    );
  }
}
