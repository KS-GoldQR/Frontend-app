import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/models/product_model.dart';
import 'package:grit_qr_scanner/provider/product_provider.dart';
import 'package:grit_qr_scanner/provider/user_provider.dart';
import 'package:grit_qr_scanner/utils/widgets/error_handling.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:grit_qr_scanner/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../utils/widgets/error_page.dart';

String testingSessionToken =
    'f992f891da40c3d251cd6fb9a5828cd84cdd363f03f7bf2571c027369afa2b8b';

// userProvider.user.sessionToken is used sessiontoken in actual

class ProductService {
  Future<List<Product>> getInventory(BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    List<Product> products = [];
    try {
      http.Response response = await http.post(
        Uri.parse('$hostedUrl/prod/users/viewInventory'),
        body: jsonEncode({
          'sessionToken': user.sessionToken,
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
        showSnackBar(
            title: 'Error',
            message: jsonDecode(response.body)['message'],
            contentType: ContentType.failure);
      }
    } catch (e) {
      showSnackBar(
          title: 'Internal Error',
          message: e.toString(),
          contentType: ContentType.failure);
    }

    return products;
  }

  Future<List<Product>> viewSoldItems(BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    List<Product> products = [];
    try {
      debugPrint(user.sessionToken);
      
      http.Response response = await http.post(
        Uri.parse('$hostedUrl/prod/users/viewSoldItems'),
        body: jsonEncode({
          'sessionToken': user.sessionToken,
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
        showSnackBar(
            title: 'Error',
            message: jsonDecode(response.body)['message'],
            contentType: ContentType.failure);
      }
    } catch (e) {
      showSnackBar(
          title: 'Internal Error',
          message: e.toString(),
          contentType: ContentType.failure);
    }

    return products;
  }

  Future<Product?> viewProduct(
      BuildContext context, String productId, String sessionToken) async {
    debugPrint("product id is $productId");
    final user = Provider.of<UserProvider>(context, listen: false).user;

    Product? product;

    try {
      http.Response response;
      if (sessionToken.isEmpty) {
        response = await http.post(
          Uri.parse('$hostedUrl/prod/products/viewProduct'),
          body: jsonEncode({
            "product_id": productId,
          }),
          headers: {'Content-Type': 'application/json'},
        );
      } else {
        response = await http.post(
          Uri.parse('$hostedUrl/prod/products/viewProduct'),
          body: jsonEncode({
            "product_id": productId,
            'sessionToken': user.sessionToken,
          }),
          headers: {'Content-Type': 'application/json'},
        );
      }

      debugPrint(response.body);
      if (response.statusCode == 200) {
        httpErrorHandle(
          response: response,
          onSuccess: () {
            product = Product.fromJson(
              jsonEncode(
                jsonDecode(response.body),
              ),
            );

            if (sessionToken.isNotEmpty) {
              Provider.of<ProductProvider>(context, listen: false)
                  .setProduct(product!);
            }
          },
        );
      } else {
        showSnackBar(
          title: 'Error',
          message: jsonDecode(response.body)['message'],
          contentType: ContentType.failure,
        );
        navigatorKey.currentState!.popAndPushNamed(
          ErrorPage.routeName,
          arguments: "Error Occurred - Bad Request",
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(
        title: 'Internal Error',
        message: e.toString(),
        contentType: ContentType.failure,
      );
      navigatorKey.currentState!.popAndPushNamed(
        ErrorPage.routeName,
        arguments: "Error Occurred - Bad Request",
      );
    }
    return product;
  }

//image should be file type, stone_price will not be manual
  Future<void> editProduct({
    required BuildContext context,
    required String productId,
    required String image,
    required String name,
    required String productType,
    required double weight,
    required String stone,
    required double stonePrice,
    required double jyala,
    required double jarti,
  }) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    try {
      debugPrint(user.sessionToken);
      debugPrint(productId);
      http.Response response = await http.post(
        Uri.parse("$hostedUrl/prod/products/editProduct"),
        body: jsonEncode({
          "product_id": productId,
          "sessionToken": user.sessionToken,
          "image": image,
          "name": name,
          "productType": productType,
          "weight": weight,
          "stone": stone,
          "stone_price": stonePrice,
          "jyala": jyala,
          "jarti": jarti
        }),
        headers: {'Content-Type': 'application/json'},
      );

      httpErrorHandle(
          response: response,
          onSuccess: () {
            showSnackBar(
                title: "Success",
                message: jsonDecode(response.body)['message'],
                contentType: ContentType.success);
            // productProvider.setProduct(product);
            Product product = productProvider.currentProduct!.copyWith(
                name: name,
                image: image,
                productType: productType,
                weight: weight,
                stone: stone,
                stone_price: stonePrice,
                jyala: jyala,
                jarti: jarti);
            productProvider.setProduct(product);
            navigatorKey.currentState!.pop();
          });
    } catch (e) {
      showSnackBar(
          title: "Error Occurred",
          message: "A unknown error occurred",
          contentType: ContentType.failure);
    }
  }

  Future<void> sellProduct(
      {required BuildContext context,
      required String productId,
      required String customerName,
      required String customerPhone,
      required String customerAddress}) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      http.Response response = await http.post(
        Uri.parse("$hostedUrl/prod/products/sellProduct"),
        body: jsonEncode({
          "sessionToken": user.sessionToken,
          "product_id": productId,
          "customer_name": customerName,
          "customer_phone": customerPhone,
          "customer_address": customerAddress,
        }),
        headers: <String, String>{'Content-Type': 'application/json'},
      );

      httpErrorHandle(
          response: response,
          onSuccess: () {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.rightSlide,
              title: 'Product Sold',
              desc: 'your product has been sold',
              btnOkText: 'OK',
            ).show();
            navigatorKey.currentState!.pop();
          });
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(
          title: "Internal Error",
          message: "an unknown error occurred!",
          contentType: ContentType.warning);
    }
  }
}
