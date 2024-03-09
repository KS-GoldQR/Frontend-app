import 'dart:convert';
import 'dart:io';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../models/product_model.dart';
import '../../../provider/product_provider.dart';
import '../../../provider/user_provider.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/utils.dart';
import '../../../utils/widgets/error_handling.dart';
import '../../../utils/widgets/error_page.dart';

class ProductService {
  Future<List<Product>> getInventory(BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    String internalError = AppLocalizations.of(context)!.internalError;
    List<Product> products = [];
    try {
      var isCacheExist =
          await APICacheManager().isAPICacheKeyExist(cacheGetInventory);

      debugPrint(isCacheExist.toString());

      if (!isCacheExist) {
        debugPrint("form api hit");
        http.Response response = await http.post(
          Uri.parse('$hostedUrl/prod/users/viewInventory'),
          body: jsonEncode({
            'sessionToken': user.sessionToken,
          }),
          headers: {'Content-Type': 'application/json'},
        );

        httpErrorHandle(
            response: response,
            onSuccess: () async {
              for (int i = 0; i < jsonDecode(response.body).length; i++) {
                products.add(
                  Product.fromMap(jsonDecode(response.body)[i]),
                );
              }

              APICacheDBModel cacheDBModel = APICacheDBModel(
                  key: cacheGetInventory, syncData: response.body);

              await APICacheManager().addCacheData(cacheDBModel);
            });
      } else {
        debugPrint("from cache hit");
        var cacheData = await APICacheManager().getCacheData(cacheGetInventory);

        for (int i = 0; i < jsonDecode(cacheData.syncData).length; i++) {
          products.add(
            Product.fromMap(jsonDecode(cacheData.syncData)[i]),
          );
        }
      }
    } catch (e) {
      showSnackBar(
          title: internalError,
          contentType: ContentType.warning);
    }

    return products;
  }

  Future<Product?> viewProduct(
      BuildContext context, String productId, String sessionToken) async {
    String internalError = AppLocalizations.of(context)!.internalError;

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

      if (response.statusCode == 200) {
        httpErrorHandle(
          response: response,
          onSuccess: () {
            if (jsonDecode(response.body)['name'] == null) {
              product = Product(
                  id: productId,
                  owned_by: -1,
                  sold: -1,
                  owner_name: "",
                  owner_phone: "",
                  validSession: "");
            } else {
              product = Product.fromJson(
                jsonEncode(
                  jsonDecode(response.body),
                ),
              );

              if (sessionToken.isNotEmpty) {
                Provider.of<ProductProvider>(context, listen: false)
                    .setProduct(product!);
              }

              navigatorKey.currentState!.pop();
            }
          },
        );
      } else {
        // debugPrint(
        // "inside success of seet product view ${response.statusCode}");
        showSnackBar(
          title: jsonDecode(response.body)['message'],
          contentType: ContentType.failure,
        );
        navigatorKey.currentState!.popAndPushNamed(
          ErrorPage.routeName,
          arguments: "Error Occurred - Bad Request",
        );
      }
    } catch (e) {
      showSnackBar(
          title: internalError,
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
    String? stone,
    double? stonePrice,
    required double jyala,
    required double jarti,
    required String jartiType,
  }) async {
    String internalError = AppLocalizations.of(context)!.internalError;
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
              title: "Failed to upload image!",
              contentType: ContentType.failure);
          return;
        } else {
          imageUrl = "$s3ImageUrl/$imageNameFromS3";
        }
      }

      //
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
          "jarti_type": jartiType,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      httpErrorHandle(
          response: response,
          onSuccess: () async {
            await APICacheManager().deleteCache(cacheGetInventory);

            Product product = productProvider.currentProduct!.copyWith(
              name: name,
              image: imageUrl,
              productType: productType,
              weight: weight,
              stone: stone ?? "None",
              stone_price: stonePrice,
              jyala: jyala,
              jarti: jarti,
              jartiType: jartiType,
            );

            productProvider.setProduct(product);
            navigatorKey.currentState!.pop();
          });
    } catch (e) {
      showSnackBar(
          title: internalError,
          contentType: ContentType.warning);
    }
  }

  Future<void> setProduct({
    required BuildContext context,
    required String productId,
    required String name,
    File? image,
    required String productType,
    required double weight,
    String? stone,
    double? stonePrice,
    required double jyala,
    required double jarti,
    required String jartiType,
  }) async {
    String internalError = AppLocalizations.of(context)!.internalError;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      String? imageNameFromS3;
      String? imageUrl;
      if (image != null) {
        imageNameFromS3 = await uploadImageToS3(context: context, file: image);

        if (imageNameFromS3 == null) {
          // showSnackBar(
          //     title: "Upload Failed",
          //     message: "failed to upload image!",
          //     contentType: ContentType.failure);
          return;
        } else {
          imageUrl = "$s3ImageUrl/$imageNameFromS3";
        }
      }

      http.Response response = await http.post(
        Uri.parse("$hostedUrl/prod/products/setProduct"),
        body: jsonEncode({
          "sessionToken": user.sessionToken,
          "product_id": productId,
          "name": name,
          "image": imageUrl ?? "",
          "productType": productType,
          "weight": weight,
          "stone": stone,
          "stone_price": stonePrice,
          "jyala": jyala,
          "jarti": jarti,
          "jarti_type": jartiType,
        }),
        headers: {"Content-Type": 'application/json'},
      );

      httpErrorHandle(
          response: response,
          onSuccess: () async {
            await APICacheManager().deleteCache(cacheGetInventory);
            navigatorKey.currentState!.pop();
          });
    } catch (e) {
      showSnackBar(
          title: internalError,
          contentType: ContentType.warning);
    }
  }
}
