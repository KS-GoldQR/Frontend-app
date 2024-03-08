import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../provider/user_provider.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/utils.dart';
import '../../../utils/widgets/error_handling.dart';
import '../../old%20products/models/old_product_model.dart';

class OldProductService {
  Future<List<OldProductModel>> getOldProducts(BuildContext context) async {
    String internalError = AppLocalizations.of(context)!.internalError;
    String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;
    List<OldProductModel> products = [];
    final user = Provider.of<UserProvider>(context, listen: false).user;
    try {
      http.Response response = await http.post(
        Uri.parse("$hostedUrl/prod/oldProduct/viewOldProducts"),
        body: jsonEncode({"sessionToken": user.sessionToken}),
        headers: {"Content-Type": "application/json"},
      );

      httpErrorHandle(
          response: response,
          onSuccess: () {
            debugPrint("success hit");
            for (int i = 0;
                i < jsonDecode(response.body)['products'].length;
                i++) {
              products.add(
                OldProductModel.fromMap(
                    jsonDecode(response.body)['products'][i]),
              );
            }
          });
    } catch (e) {
      debugPrint(e.toString());
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
    String? stone,
    double? stonePrice,
    double? charge,
    required double rate,
    double? loss,
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
          onSuccess: () {
            navigatorKey.currentState!.pop();
          });
    } catch (e) {
      showSnackBar(
          title: internalError,
          message: unknownError,
          contentType: ContentType.warning);
    }
  }

  Future<bool> deleteOldProduct(
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
            // showSnackBar(
            //     title: "image Upload Success",
            //     message: "",
            //     contentType: ContentType.success);
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
