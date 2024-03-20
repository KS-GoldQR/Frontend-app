import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'features/auth/screens/login_screen.dart';
import 'services/user_service.dart';
import 'features/home/screens/home_screen.dart';
import 'features/home/screens/splash_screen.dart';
import 'provider/language_provider.dart';
import 'provider/order_provider.dart';
import 'provider/product_provider.dart';
import 'provider/sales_provider.dart';
import 'provider/user_provider.dart';
import 'routers.dart';
import 'utils/global_variables.dart';

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
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageChangeProvider>(
      builder: (_, provider, child) {
        // Retrieve stored language code or default to 'ne'
        final String storedLanguage =
            widget.languageCode.isNotEmpty ? widget.languageCode : 'ne';

        if (provider.appLocale == null) {
          // Set the initial language based on stored preferences
          provider.changeLangauge(Locale(storedLanguage));
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
                  color: Colors.white, // Set the color of the back button here
                ),
                actionsIconTheme: IconThemeData(color: Colors.white),
                titleTextStyle: TextStyle(
                    color: Colors.white, fontSize: 25, fontFamily: "Poppins")),
          ),
          locale: provider.appLocale,
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
          home: const MainPage(),
        );
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final UserService _userService = UserService();
  final Uri _url = Uri.parse('https://sulabh.info.np/SmartSunar');
  bool? isValidated;
  bool toUpdate = false;
  String? appVersion;
  String? appName;
  String? apiAppVersion;

  Future<void> getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    appName = packageInfo.appName;
  }

  Future<void> getValidation() async {
    isValidated = await _userService.validateSession(context);
    if (mounted) {
      setState(() {});
    }
  }

  void toUpdateApp() {
    if (isValidated!) {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      apiAppVersion = user.appVersion!;
      int appVersionNumber = getExtendedVersionNumber(appVersion!);
      int apiVersionNumber = getExtendedVersionNumber(apiAppVersion!);

      if (apiVersionNumber > appVersionNumber) {
        if (mounted) {
          setState(() {
            toUpdate = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            toUpdate = false;
          });
        }
      }
    }
  }

  int getExtendedVersionNumber(String version) {
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
    launchUrl(
      _url,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await getAppInfo();
      await getValidation();
      toUpdateApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        isValidated == null
            ? const SplashScreen()
            : isValidated!
                ? const HomeScreen()
                : const LoginScreen(),
        if (toUpdate)
          UpdateAlertDialog(
            appName: "smart sunar",
            appVersion: apiAppVersion!,
            onUpdate: () {
              setState(() {
                toUpdate = false;
              });
              _launchUrl();
            },
            onCancel: () {
              setState(() {
                toUpdate = false;
              });
            },
          )
      ],
    );
  }
}

class UpdateAlertDialog extends StatelessWidget {
  final String appName;
  final String appVersion;
  final VoidCallback onUpdate;
  final VoidCallback onCancel;

  const UpdateAlertDialog({
    super.key,
    required this.appName,
    required this.appVersion,
    required this.onUpdate,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blurred background
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            color:
                Colors.black.withOpacity(0.3), // Adjust the opacity as needed
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        // Actual dialog
        AlertDialog(
          title: const Text('New Update Available'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'A new version of $appName ($appVersion) is available.',
                style: const TextStyle(fontSize: 16.0),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: onCancel,
              child: const Text(
                'Not Now',
                style: TextStyle(color: blueColor),
              ),
            ),
            ElevatedButton(
              onPressed: onUpdate,
              child: const Text(
                'Update Now',
                style: TextStyle(color: blueColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
