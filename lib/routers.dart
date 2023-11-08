import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/screens/qr_scanner_screen.dart';
import 'package:grit_qr_scanner/screens/result_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case QRScannerScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const QRScannerScreen(),
      );

    case ResultScreen.routeName:
      var scannedResult = routeSettings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => ResultScreen(
          args: scannedResult,
        ),
      );

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text("Error Occurred!"),
          ),
        ),
      );
  }
}
