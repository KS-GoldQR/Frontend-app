import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/utils/env.dart';

String hostedUrl = Env.hostedUrl;
final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

DateTime lastUpdated = DateTime.now();

const Color greyColor = Color(0xFF444242);
const Color blueColor = Color(0xFF276080);
const Color formBorderColor = Color(0xFF828080);

void runMe() {
  debugPrint(hostedUrl);
}
