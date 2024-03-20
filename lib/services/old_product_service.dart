import 'dart:convert';
import 'dart:io';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import '../utils/widgets/error_handling.dart';
import '../models/old_product_model.dart';

class OldProductService {
  Future<List<OldProductModel>> getOldProducts(BuildContext context) async {
    String internalError = AppLocalizations.of(context)!.internalError;
    List<OldProductModel> products = [];
    final user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      var isCacheExist =
          await APICacheManager().isAPICacheKeyExist(cacheGetOldProducts);

      if (!isCacheExist) {
        http.Response response = await http.post(
          Uri.parse("$hostedUrl/prod/oldProduct/viewOldProducts"),
          body: jsonEncode({"sessionToken": user.sessionToken}),
          headers: {"Content-Type": "application/json"},
        );

        httpErrorHandle(
            response: response,
            onSuccess: () async {
              debugPrint("success api hit");
              for (int i = 0;
                  i < jsonDecode(response.body)['products'].length;
                  i++) {

                // TODO : date is not parsing as expected
                products.add(
                  OldProductModel.fromMap(
                      jsonDecode(response.body)['products'][i]),
                );
              }

              APICacheDBModel cacheDBModel = APICacheDBModel(
                  key: cacheGetOldProducts, syncData: response.body);

              await APICacheManager().addCacheData(cacheDBModel);
            });
      } else {
        var cacheData =
            await APICacheManager().getCacheData(cacheGetOldProducts);

        debugPrint("cache hit");
        for (int i = 0;
            i < jsonDecode(cacheData.syncData)['products'].length;
            i++) {
          products.add(
            OldProductModel.fromMap(
                jsonDecode(cacheData.syncData)['products'][i]),
          );
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(title: internalError, contentType: ContentType.warning);
    }
    return products;
  }

  Future<void> addOldProduct({
    required BuildContext context,
    File? image,
    required String name,
    required String productType,
    required double weight,
    String? stone,
    double? stonePrice,
    double? charge,
    required double rate,
    double? loss,
  }) async {
    String internalError = AppLocalizations.of(context)!.internalError;
    final user = Provider.of<UserProvider>(context, listen: false).user;
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

      http.Response response = await http.post(
        Uri.parse("$hostedUrl/prod/oldProduct/addoldProduct"),
        body: jsonEncode({
          "sessionToken": user.sessionToken,
          "image": imageUrl ?? "",
          "name": name,
          "productType": productType,
          "weight": weight,
          "stone": stone,
          "stone_price": stonePrice,
          "charge": charge,
          "loss": loss,
          "rate": rate,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      httpErrorHandle(
          response: response,
          onSuccess: () async {
            await APICacheManager().deleteCache(cacheGetOldProducts);
            navigatorKey.currentState!.pop();
          });
    } catch (e) {
      showSnackBar(title: internalError, contentType: ContentType.warning);
    }
  }

  Future<bool> deleteOldProduct(
      {required BuildContext context, required String productId}) async {
    String internalError = AppLocalizations.of(context)!.internalError;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      http.Response response = await http.post(
          Uri.parse("$hostedUrl/prod/oldProduct/deleteOldProduct"),
          body: jsonEncode(
              {"sessionToken": user.sessionToken, "product_id": productId}),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        await APICacheManager().deleteCache(cacheGetOldProducts);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      showSnackBar(title: internalError, contentType: ContentType.warning);
    }
    return false;
  }
}
