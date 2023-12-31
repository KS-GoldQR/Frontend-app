import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/models/product_model.dart';
import 'package:grit_qr_scanner/provider/user_provider.dart';
import 'package:grit_qr_scanner/utils/widgets/error_handling.dart';
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
        Uri.parse('$hostedUrl/viewInventory'),
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
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    List<Product> products = [];
    try {
      http.Response response = await http.post(
        Uri.parse('$hostedUrl/viewSoldItems'),
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

  Future<Product?> viewProduct(BuildContext context, String productId) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    Product? product;
    try {
      debugPrint(productId);
      http.Response response = await http.post(
        Uri.parse('$hostedUrl/viewProduct'),
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
        showSnackBar(
            title: 'Error',
            message: jsonDecode(response.body)['message'],
            contentType: ContentType.failure);
        // navigatorKey.currentState!.pushNamed(ErrorPage.routeName);
      }
    } catch (e) {
      showSnackBar(
          title: 'Internal Error',
          message: e.toString(),
          contentType: ContentType.failure);
    }
    return product;
  }

  Future<void> addProduct(BuildContext context, File image) async {
    /*
    //testing with image as string
    List<int> imageBytes = image.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    debugPrint(base64Image);

    Uint8List bytes = base64Decode(base64Image);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Image Dialog'),
          content: Image.memory(bytes),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
            
          ],
        );
      },
    );
    */
    try {} catch (e) {
      debugPrint("error $e");
    }
  }
}
