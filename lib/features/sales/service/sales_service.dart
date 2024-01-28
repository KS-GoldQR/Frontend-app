import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/models/product_model.dart';
import 'package:grit_qr_scanner/provider/user_provider.dart';
import 'package:grit_qr_scanner/utils/widgets/error_handling.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:grit_qr_scanner/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class SalesService {
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

  Future<bool> sellProduct(
      {required BuildContext context,
      required String productId,
      required String customerName,
      required String customerPhone,
      required String customerAddress,
      required double productTotalPrice,
      required double jyala,
      required double jarti}) async {
    String internalError = AppLocalizations.of(context)!.internalError;
    String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    bool isSold = false;

    try {
      debugPrint("here");

      //after modification in api sent jyala, jarti too in api
      debugPrint(productTotalPrice.toString());
      http.Response response = await http.post(
        Uri.parse("$hostedUrl/prod/products/sellProduct"),
        body: jsonEncode({
          "sessionToken": user.sessionToken,
          "product_id": productId,
          "customer_name": customerName,
          "customer_phone": customerPhone,
          "customer_address": customerAddress,
          "price": productTotalPrice.toString(),
          "jyala": jyala,
          "jarti": jarti
        }),
        headers: <String, String>{'Content-Type': 'application/json'},
      );

      httpErrorHandle(
          response: response,
          onSuccess: () {
            isSold = true;
            showSnackBar(
                title: 'Product Sold',
                message: 'your product has been sold',
                contentType: ContentType.success);
          });
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(
          title: internalError,
          message: unknownError,
          contentType: ContentType.warning);
    }
    return isSold;
  }
}
