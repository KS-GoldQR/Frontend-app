import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/models/product_model.dart';
import 'package:grit_qr_scanner/provider/product_provider.dart';
import 'package:grit_qr_scanner/provider/user_provider.dart';
import 'package:grit_qr_scanner/utils/widgets/error_handling.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:grit_qr_scanner/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

import '../../../utils/widgets/error_page.dart';

String testingSessionToken =
    'f992f891da40c3d251cd6fb9a5828cd84cdd363f03f7bf2571c027369afa2b8b';

class ProductService {
  Future<List<Product>> getInventory(BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    String internalError = AppLocalizations.of(context)!.internalError;
    String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;
    List<Product> products = [];
    try {
      debugPrint(user.sessionToken);
      debugPrint(user.userId);
      http.Response response = await http.post(
        Uri.parse('$hostedUrl/prod/users/viewInventory'),
        body: jsonEncode({
          'sessionToken': user.sessionToken,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        debugPrint(response.body);
        httpErrorHandle(
            response: response,
            onSuccess: () {
              for (int i = 0; i < jsonDecode(response.body).length; i++) {
                products.add(
                  Product.fromMap(jsonDecode(response.body)[i]),
                );
              }
            });
      } else {
        showSnackBar(
            title: 'Error',
            message: "No products in Inventory",
            contentType: ContentType.failure);
      }
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(
          title: internalError,
          message: unknownError,
          contentType: ContentType.warning);
    }

    return products;
  }

  Future<List<Product>> viewSoldItems(BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    String internalError = AppLocalizations.of(context)!.internalError;
    String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;
    List<Product> products = [];
    try {
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
          title: internalError,
          message: unknownError,
          contentType: ContentType.warning);
    }

    return products;
  }

  Future<Product?> viewProduct(
      BuildContext context, String productId, String sessionToken) async {
    String internalError = AppLocalizations.of(context)!.internalError;
    String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;
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
          title: internalError,
          message: unknownError,
          contentType: ContentType.warning);
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
    File? image,
    required String name,
    required String productType,
    required double weight,
    required String stone,
    required double stonePrice,
    required double jyala,
    required double jarti,
  }) async {
    String internalError = AppLocalizations.of(context)!.internalError;
    String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    try {
      String? imageNameFromS3;
      String? imageUrl;
      if (image != null) {
        imageNameFromS3 = await uploadImageToS3(context: context, file: image);

        if (imageNameFromS3 == null) {
          showSnackBar(
              title: "Upload Failed",
              message: "failed to upload image!",
              contentType: ContentType.failure);
          return;
        } else {
          imageUrl = "$s3ImageUrl/$imageNameFromS3";
        }
      }

      debugPrint("hello");

      // debugPrint("from service : ${imageUrl}");
      http.Response response = await http.post(
        Uri.parse("$hostedUrl/prod/products/editProduct"),
        body: jsonEncode({
          "product_id": productId,
          "sessionToken": user.sessionToken,
          "image": imageUrl ?? productProvider.currentProduct!.image,
          "name": name,
          "productType": productType,
          "weight": weight,
          "stone": stone,
          "stone_price": stonePrice,
          "jyala": jyala,
          "jarti": jarti,
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
              image: imageUrl,
              productType: productType,
              weight: weight,
              stone: stone,
              stone_price: stonePrice,
              jyala: jyala,
              jarti: jarti,
            );
            productProvider.setProduct(product);
            navigatorKey.currentState!.pop();
          });
    } catch (e) {
      showSnackBar(
          title: internalError,
          message: unknownError,
          contentType: ContentType.warning);
    }
  }

  Future<void> sellProduct(
      {required BuildContext context,
      required String productId,
      required String customerName,
      required String customerPhone,
      required String customerAddress,
      required double productPrice}) async {
    String internalError = AppLocalizations.of(context)!.internalError;
    String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      debugPrint("here");
      debugPrint(productPrice.toString());
      http.Response response = await http.post(
        Uri.parse("$hostedUrl/prod/products/sellProduct"),
        body: jsonEncode({
          "sessionToken": user.sessionToken,
          "product_id": productId,
          "customer_name": customerName,
          "customer_phone": customerPhone,
          "customer_address": customerAddress,
          "price": productPrice.toString(),
        }),
        headers: <String, String>{'Content-Type': 'application/json'},
      );

      httpErrorHandle(
          response: response,
          onSuccess: () {
            showSnackBar(
                title: 'Product Sold',
                message: 'your product has been sold',
                contentType: ContentType.success);
            navigatorKey.currentState!.pop();
          });
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(
          title: internalError,
          message: unknownError,
          contentType: ContentType.warning);
    }
  }

  Future<void> setProduct({
    required BuildContext context,
    required String productId,
    required String name,
    required String image,
    required String productType,
    required double weight,
    required String stone,
    required double stonePrice,
    required double jyala,
    required double jarti,
  }) async {
    String internalError = AppLocalizations.of(context)!.internalError;
    String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      http.Response response = await http.post(
        Uri.parse("$hostedUrl/prod/products/setProduct"),
        body: jsonEncode({
          "sessionToken": user.sessionToken,
          "product_id": productId,
          "name": name,
          "image": image,
          "productType": productType,
          "weight": weight,
          "stone": stone,
          "stone_price": stonePrice,
          "jyala": jyala,
          "jarti": jarti
        }),
        headers: {"Content-Type": 'application/json'},
      );

      httpErrorHandle(
          response: response,
          onSuccess: () {
            showSnackBar(
                title: "Success",
                message: "product set successfully",
                contentType: ContentType.success);
          });
    } catch (e) {
      showSnackBar(
          title: internalError,
          message: unknownError,
          contentType: ContentType.warning);
    }
  }

  Future<String?> uploadImageToS3(
      {required BuildContext context, required File file}) async {
    String internalError = AppLocalizations.of(context)!.internalError;
    String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;
    String? fileName;
    try {
      List<int> imageBytes = file.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);

      http.Response response = await http.put(
          Uri.parse("$hostedUrl/prod/upload"),
          body: jsonEncode({"file": base64Image}),
          headers: {"Content-Type": "application/json"});

      httpErrorHandle(
          response: response,
          onSuccess: () {
            fileName = jsonDecode(response.body)['fileName'];
            showSnackBar(
                title: "image Upload Success",
                message: "",
                contentType: ContentType.success);
          });
    } catch (e) {
      showSnackBar(
          title: internalError,
          message: unknownError,
          contentType: ContentType.warning);
    }
    return fileName!;
  }
}
