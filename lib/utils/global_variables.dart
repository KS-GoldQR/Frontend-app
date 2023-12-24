import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String  hostedUrl = dotenv.env['hostedUrl']!;
final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
const Color greyColor = Color(0xFF444242);
const Color blueColor = Color(0xFF276080);
const Color formBorderColor = Color(0xFF828080);
