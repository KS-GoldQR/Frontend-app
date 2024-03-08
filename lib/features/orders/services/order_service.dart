import 'dart:convert';
import 'dart:core';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../models/order_model.dart';
import '../../../provider/order_provider.dart';
import '../../../provider/user_provider.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/utils.dart';
import '../../../utils/widgets/error_handling.dart';
import '../../home/screens/home_screen.dart';
import '../screens/order_screen.dart';

class OrderService {
  Future<List<Order>> getAllOrders(BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    String internalError = AppLocalizations.of(context)!.internalError;
    String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;
    List<Order> orders = [];
    try {
      http.Response response = await http.post(
        Uri.parse("$hostedUrl/prod/orders/viewOrders"),
        body: jsonEncode({
          'sessionToken': user.sessionToken,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      httpErrorHandle(
          response: response,
          onSuccess: () {
            //Response is modified to convert it as valid json object: Should be removed if json is valid & not a good practice
            final jsonResponse = jsonDecode(response.body);
            dynamic ordersJson = jsonResponse['orders']
                .replaceAll("'", '"')
                .replaceAll('Decimal(', '')
                .replaceAll(')', '')
                .replaceAll('["', '[')
                .replaceAll('"]', ']')
                .replaceAll('"{', '{')
                .replaceAll('}"', '}');

            if (ordersJson is String) {
              final modifiedOrdersJson = jsonDecode(ordersJson);
              debugPrint(modifiedOrdersJson.toString());

              if (modifiedOrdersJson is List<dynamic>) {
                orders = modifiedOrdersJson.map((orderJson) {
                  if (orderJson is Map<String, dynamic>) {
                    return Order.fromMap(orderJson);
                  } else {
                    return Order.fromJson(orderJson.toString());
                  }
                }).toList();
              }
            }
            orderProvider.resetOrders();
          });
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(
          title: internalError,
          message: unknownError,
          contentType: ContentType.warning);
    }

    return orders;
  }

  Future<void> addOrder(BuildContext context) async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final user = Provider.of<UserProvider>(context, listen: false).user;

    String internalError = AppLocalizations.of(context)!.internalError;
    String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;
    try {
      http.Response response = await http.post(
        Uri.parse('$hostedUrl/prod/orders/addOrder'),
        body: jsonEncode({
          "sessionToken": user.sessionToken,
          "customer_name": orderProvider.customer!.name,
          "customer_phone": orderProvider.customer!.phone,
          "expected_deadline":
              orderProvider.customer!.expectedDeadline?.toIso8601String(),
          "advance_payment": orderProvider.customer!.advance,
          "ordered_items": orderProvider.orderedItems,
          "old_jwellery": orderProvider.oldJwelleries,
          "address": orderProvider.customer!.address,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      httpErrorHandle(
          response: response,
          onSuccess: () {
            showSnackBar(
                title: "Order Added!",
                message: jsonDecode(response.body)['message'],
                contentType: ContentType.success);

            orderProvider.resetOrders();

            // Navigate to HomeScreen and remove all screens until HomeScreen
            navigatorKey.currentState!.pushNamedAndRemoveUntil(
                HomeScreen.routeName, (route) => false);

            // Push OrdersScreen on top of the navigation stack
            navigatorKey.currentState!.pushNamed(OrderScreen.routeName);
          });
    } catch (e) {
      showSnackBar(
          title: internalError,
          message: unknownError,
          contentType: ContentType.warning);
    }
  }

  Future<bool> deleteOrder(
      {required BuildContext context, required String orderId}) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    String internalError = AppLocalizations.of(context)!.internalError;
    String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;
    try {
      http.Response response = await http.post(
        Uri.parse("$hostedUrl/prod/orders/deleteOrder"),
        body: jsonEncode({
          "sessionToken": user.sessionToken,
          "order_id": orderId,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      showSnackBar(
          title: internalError,
          message: unknownError,
          contentType: ContentType.warning);
    }
    return false;
  }
}
