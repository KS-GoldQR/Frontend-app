import 'package:flutter/material.dart';

import 'features/auth/screens/login_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/home/screens/qr_scanner_screen.dart';
import 'features/home/screens/user_details_screen.dart';
import 'features/old products/screens/old_product_screen.dart';
import 'features/orders/screens/create_order_screen.dart';
import 'features/orders/screens/customer_details_screen.dart';
import 'features/orders/screens/old_jwellery_screen.dart';
import 'features/orders/screens/order_screen.dart';
import 'features/products/screens/about_product_screen.dart';
import 'features/products/screens/edit_product_screen.dart';
import 'features/products/screens/view_inventory_screen.dart';
import 'features/reusable%20components/final_preview_screen.dart';
import 'features/sales/screens/sales_screen.dart';
import 'utils/widgets/error_page.dart';

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

    case ViewInventoryScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const ViewInventoryScreen(),
      );

    case SalesScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const SalesScreen(),
      );

    case AboutProduct.routeName:
      final args = routeSettings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => AboutProduct(args: args),
      );

    case EditProductScreen.routeName:
      final args = routeSettings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (context) => EditProductScreen(args: args),
      );

    case OrderScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const OrderScreen(),
      );

    case CreateOrderScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const CreateOrderScreen(),
      );

    case OldJwelleryScreen.routeName:
      final bool isSales = routeSettings.arguments as bool;
      return MaterialPageRoute(
        builder: (context) => OldJwelleryScreen(isSales: isSales),
      );

    case OldProductsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const OldProductsScreen(),
      );

    case CustomerDetailsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const CustomerDetailsScreen(),
      );

    case UserDetailsScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserDetailsScreen(),
      );

    case FinalPreviewScreen.routeName:
      final bool isSales = routeSettings.arguments as bool;
      return MaterialPageRoute(
        builder: (context) => FinalPreviewScreen(isSales: isSales),
      );

    case ErrorPage.routeName:
      final String message = routeSettings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => ErrorPage(message: message),
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
