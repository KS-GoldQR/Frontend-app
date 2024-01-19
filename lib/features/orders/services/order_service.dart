import 'dart:convert';
import 'dart:core';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/features/orders/screens/order_screen.dart';
import 'package:grit_qr_scanner/models/order_model.dart';
import 'package:grit_qr_scanner/provider/order_provider.dart';
import 'package:grit_qr_scanner/provider/user_provider.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:grit_qr_scanner/utils/utils.dart';
import 'package:grit_qr_scanner/utils/widgets/error_handling.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


String testingSessionToken =
    "f992f891da40c3d251cd6fb9a5828cd84cdd363f03f7bf2571c027369afa2b8b";

class OrderService {
  Future<List<Order>> getAllOrders(BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    List<Order> orders = [];
    try {
      http.Response response = await http.post(
        Uri.parse("$hostedUrl/prod/orders/viewOrders"),
        body: jsonEncode({
          'sessionToken': testingSessionToken,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
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

                // debugPrint(modifiedOrdersJson.toString());

                if (modifiedOrdersJson is List<dynamic>) {
                  orders = modifiedOrdersJson.map((orderJson) {
                    debugPrint(orderJson.toString());
                    if (orderJson is Map<String, dynamic>) {
                      return Order.fromMap(orderJson);
                    } else {
                      return Order.fromJson(orderJson.toString());
                    }
                  }).toList();
                }
              }
            });
      } else {
        showSnackBar(
            title: "Failed",
            message: "failed to fetch orders",
            contentType: ContentType.warning);
      }
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(
          title: "Internal Error",
          message: "An unknown error occurred",
          contentType: ContentType.failure);
    }

    return orders;
  }

  Future<void> addOrder(BuildContext context) async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response response = await http.post(
        Uri.parse('$hostedUrl/prod/orders/addOrder'),
        body: jsonEncode({
          "sessionToken": testingSessionToken,
          "customer_name": orderProvider.customer!.name,
          "customer_phone": orderProvider.customer!.phone,
          "expected_deadline":
              orderProvider.customer!.expectedDeadline.toIso8601String(),
          "advance_payment": orderProvider.customer!.advance,
          "ordered_items": orderProvider.orderedItems,
          "old_jwellery": orderProvider.oldJewelries,
          "address": orderProvider.customer!.address,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        httpErrorHandle(
            response: response,
            onSuccess: () {
              debugPrint(jsonDecode(response.body)['id']);
              showSnackBar(
                  title: "Order Added!",
                  message: jsonDecode(response.body)['message'],
                  contentType: ContentType.success);
              navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  OrderScreen.routeName, ModalRoute.withName('/home-screen'));

            });
      } else {
        showSnackBar(
            title: "Order Failed!",
            message: "failed to add order",
            contentType: ContentType.failure);
      }
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(
          title: "Error Occurred!",
          message: "Internal Error Occurred",
          contentType: ContentType.failure);
    }
  }

  Future<void> deleteOrder(
      {required BuildContext context, required String orderId}) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      http.Response response = await http.post(
        Uri.parse("$hostedUrl/prod/orders/deleteOrder"),
        body: jsonEncode({
          "sessionToken": testingSessionToken,
          "order_id": orderId,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        httpErrorHandle(
            response: response,
            onSuccess: () {
              showSnackBar(
                  title: "Order Deleted",
                  message: "order is been delete form list",
                  contentType: ContentType.success);
            });
      } else {
        showSnackBar(
            title: "Deletion Failed!",
            message: "order has not been deleted",
            contentType: ContentType.failure);
      }
    } catch (e) {
      showSnackBar(
          title: "Error Occurred!",
          message: "Internal Error Occurred",
          contentType: ContentType.failure);
    }
  }
}
