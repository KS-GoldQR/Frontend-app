import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/models/product_model.dart';
import 'package:grit_qr_scanner/provider/user_provider.dart';
import 'package:grit_qr_scanner/utils/error_handling.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:grit_qr_scanner/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

String testingSessionToken =
    '9cc5b723f2ef2674f09fb4da7c2fe291b0b0db68b13573bbcbc8f6c3a591a51c';

// userProvider.user.sessionToken is used sessiontoken in actual

class ProductService {
  Future<List<Product>> getInventory(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> products = [];
    try {
      http.Response response = await http.post(
        Uri.parse('$hostedUrl/users/viewInventory'),
        body: jsonEncode({
          'sessionToken': testingSessionToken,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        httpErrorHandle(
            response: response,
            onSuccess: () {
              for (int i = 0; i < jsonDecode(response.body).length; i++) {
                products.add(
                  Product.fromJson(
                    jsonEncode(jsonDecode(response.body)[i]),
                  ),
                );
              }
            });
      } else {
        showSnackBar(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      showSnackBar("Internal error: $e");
    }

    return products;
  }

  Future<List<Product>> viewSoldItems(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    List<Product> products = [];
    try {
      http.Response response = await http.post(
        Uri.parse('$hostedUrl/users/viewSoldItems'),
        body: jsonEncode({
          'sessionToken': userProvider.user.sessionToken,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        httpErrorHandle(
            response: response,
            onSuccess: () {
              for (int i = 0; i < jsonDecode(response.body).length; i++) {
                products.add(
                  Product.fromJson(
                    jsonEncode(jsonDecode(response.body)[i]),
                  ),
                );
              }
            });
      } else {
        showSnackBar(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      showSnackBar("Internal error: $e");
    }

    return products;
  }

  Future<Product?> viewProduct(BuildContext context, String productId) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    Product? product;
    try {
      debugPrint(productId);
      http.Response response = await http.post(
        Uri.parse('$hostedUrl/users/viewProduct'),
        body: jsonEncode({
          "product_id": productId,
          "sessionToken": testingSessionToken,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint(jsonDecode(response.body)['statusCode'].toString());

      if (jsonDecode(response.body)['statusCode'] == 200) {
        httpErrorHandle(
            response: response,
            onSuccess: () {
              product = Product.fromJson(
                jsonEncode(
                  jsonDecode(response.body),
                ),
              );
            });
      } else {
        showSnackBar(jsonDecode(response.body)['body']);
        // navigatorKey.currentState!.pushNamed(ErrorPage.routeName);
      }
    } catch (e) {
      showSnackBar("Internal error: $e");
    }

    return product;
  }
}
