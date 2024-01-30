import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/models/product_model.dart';
import 'package:grit_qr_scanner/provider/user_provider.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:grit_qr_scanner/utils/utils.dart';
import 'package:grit_qr_scanner/utils/widgets/error_handling.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class OldProductService {
  Future<List<Product>> getOldProducts(BuildContext context) async {
    String internalError = AppLocalizations.of(context)!.internalError;
    String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;
    List<Product> products = [];
    final user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      http.Response response = await http.post(
          Uri.parse("$hostedUrl/prod/oldProduct/viewOldProducts"),
          body: jsonEncode({"sessionToken": user.sessionToken}),
          headers: {"Content-Type": "application/json"});

      httpErrorHandle(
          response: response,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(response.body).length; i++) {
              products.add(
                Product.fromMap(jsonDecode(response.body)[i]),
              );
            }
          });
    } catch (e) {
      showSnackBar(
          title: internalError,
          message: unknownError,
          contentType: ContentType.warning);
    }
    return products;
  }

  Future<void> addOldProduct({
    required BuildContext context,
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

      // debugPrint(
      //     "$name $imageUrl $productType ${weight.toInt()} $stone $stonePrice $jyala $jarti");

      //problem from backed is 500 this is because float is not acceptable in backend...
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
          "jyala": jyala,
          "jarti": jarti
        }),
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint("api hitting old product");
      debugPrint(response.statusCode.toString());

      httpErrorHandle(
          response: response,
          onSuccess: () {
            debugPrint("success adding old product");
            showSnackBar(
                title: "Success",
                message: jsonDecode(response.body)['message'],
                contentType: ContentType.success);
            navigatorKey.currentState!.pop();
          });
    } catch (e) {
      showSnackBar(
          title: internalError,
          message: unknownError,
          contentType: ContentType.warning);
    }
  }

  Future<void> deleteOldProduct(
      {required BuildContext context, required String productId}) async {
    String internalError = AppLocalizations.of(context)!.internalError;
    String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      http.Response response = await http.post(
          Uri.parse("$hostedUrl/prod/oldProduct/deleteOldProduct"),
          body: jsonEncode(
              {"sessionToken": user.sessionToken, "product_id": productId}),
          headers: {"Content-Type": "application/json"});

      httpErrorHandle(
          response: response,
          onSuccess: () {
            showSnackBar(
                title: "Deleted",
                message: "Old product deleted successfully",
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
