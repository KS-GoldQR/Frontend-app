
import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/features/products/screens/add_product_screen.dart';
import 'package:grit_qr_scanner/features/products/screens/sell_product_screen.dart';
import 'package:grit_qr_scanner/features/products/screens/view_inventory_screen.dart';
import 'package:grit_qr_scanner/features/products/screens/sold_items_screen.dart';
import 'package:grit_qr_scanner/features/products/screens/about_product_screen.dart';
import 'package:grit_qr_scanner/features/home/screens/home_screen.dart';
import 'package:grit_qr_scanner/features/auth/screens/login_screen.dart';
import 'package:grit_qr_scanner/features/home/screens/qr_scanner_screen.dart';
import 'package:grit_qr_scanner/utils/widgets/error_page.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case QRScannerScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const QRScannerScreen(),
      );

    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const LoginScreen(),
      );

    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const HomeScreen(),
      );

    case ViewInventoryScreeen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const ViewInventoryScreeen(),
      );

    case SoldItemsScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const SoldItemsScreen(),
      );

    case AboutProduct.routeName:
      final args = routeSettings.arguments as Map<String,dynamic>;
      return MaterialPageRoute(
        builder: (context) => AboutProduct(args: args),
        
      );

    case AddProductScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const AddProductScreen(),
      );

    case SellProductScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SellProductScreen(),
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
