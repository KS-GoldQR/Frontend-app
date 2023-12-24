import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/features/products/screens/add_product_screen.dart';
import 'package:grit_qr_scanner/features/products/screens/view_inventory_screen.dart';
import 'package:grit_qr_scanner/features/products/screens/sold_items_screen.dart';
import 'package:grit_qr_scanner/features/products/screens/about_product_screen.dart';
import 'package:grit_qr_scanner/screens/home_screen.dart';
import 'package:grit_qr_scanner/features/auth/screens/login_screen.dart';
import 'package:grit_qr_scanner/screens/qr_scanner_screen.dart';
import 'package:grit_qr_scanner/screens/result_screen.dart';
import 'package:grit_qr_scanner/utils/error_page.dart';

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

    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );

    case HomeScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );

    case ViewInventoryScreeen.routeName:
      return MaterialPageRoute(
        builder: (context) => const ViewInventoryScreeen(),
      );

    case SoldItemsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SoldItemsScreen(),
      );

    case AboutProduct.routeName:
      String productId = "P1";
      return MaterialPageRoute(
        builder: (context) => AboutProduct(productId: productId),
      );

    case AddProductScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const AddProductScreen(),
      );

    case ErrorPage.routeName:
      return MaterialPageRoute(
        builder: (context) => const ErrorPage(),
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
