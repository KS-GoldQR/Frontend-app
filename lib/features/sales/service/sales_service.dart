import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/features/home/screens/home_screen.dart';
import 'package:grit_qr_scanner/features/orders/models/old_jwellery_model.dart';
import 'package:grit_qr_scanner/features/sales/models/sold_product_model.dart';
import 'package:grit_qr_scanner/features/sales/screens/sales_screen.dart';
import 'package:grit_qr_scanner/models/sales_model.dart';
import 'package:grit_qr_scanner/provider/sales_provider.dart';
import 'package:grit_qr_scanner/provider/user_provider.dart';
import 'package:grit_qr_scanner/utils/widgets/error_handling.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:grit_qr_scanner/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

class SalesService {
  Future<List<SalesModel>> viewSoldItems(BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    String internalError = AppLocalizations.of(context)!.internalError;
    String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;
    List<SalesModel> sales = [];
    try {
      http.Response response = await http.post(
        Uri.parse('$hostedUrl/prod/sales/viewSales'),
        body: jsonEncode({
          'session_token': user.sessionToken,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        httpErrorHandle(
            response: response,
            onSuccess: () {
              List<dynamic> salesList = jsonDecode(response.body)['sales'];
              for (int i = 0; i < salesList.length; i++) {
                debugPrint("hello");

                // Extract and modify the string representation of 'rate'
                String modifiedRate = salesList[i]['rate']
                    .replaceAll("'", '"')
                    .replaceAll('Decimal(', '')
                    .replaceAll(')', '')
                    .replaceAll('["', '[')
                    .replaceAll('"]', ']')
                    .replaceAll('"{', '{')
                    .replaceAll('}"', '}');

                // Extract and modify the string representation of 'products'
                String modifiedProducts = salesList[i]['products']
                    .replaceAll("'", '"')
                    .replaceAll('Decimal(', '')
                    .replaceAll(')', '')
                    .replaceAll('["', '[')
                    .replaceAll('"]', ']')
                    .replaceAll('"{', '{')
                    .replaceAll('}"', '}');

                // Extract and modify the string representation of 'old_products'
                String modifiedOldProducts = salesList[i]['old_products']
                    .replaceAll("'", '"')
                    .replaceAll('Decimal(', '')
                    .replaceAll(')', '')
                    .replaceAll('["', '[')
                    .replaceAll('"]', ']')
                    .replaceAll('"{', '{')
                    .replaceAll('}"', '}');

                // Parse modified strings back to maps/lists
                Map<String, dynamic> rate = jsonDecode(modifiedRate);
                List<dynamic> products = jsonDecode(modifiedProducts);
                List<dynamic> oldProducts = jsonDecode(modifiedOldProducts);

                // Replace the original fields with parsed versions
                salesList[i]['rate'] = rate;
                salesList[i]['products'] = products;
                salesList[i]['old_products'] = oldProducts;

                debugPrint("sir");

                // Continue with creating SalesModel
                sales.add(SalesModel.fromMap(salesList[i]));

                debugPrint("ji");
              }
            });
      } else {
        showSnackBar(
            title: 'Error',
            message: jsonDecode(response.body)['message'],
            contentType: ContentType.failure);
      }
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(
          title: internalError,
          message: unknownError,
          contentType: ContentType.warning);
    }

    debugPrint(sales.toString());

    return sales;
  }

  Future<bool> sellProduct({
    required BuildContext context,
    required String customerName,
    required String customerPhone,
    required List<SoldProduct> products,
    required List<OldJwellery> oldProducts,
  }) async {
    String internalError = AppLocalizations.of(context)!.internalError;
    String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final salesProvider = Provider.of<SalesProvider>(context, listen: false);
    try {
      http.Response response = await http.post(
        Uri.parse("$hostedUrl/prod/sales/addSales"),
        body: jsonEncode({
          "session_token": user.sessionToken,
          "customer_name": customerName,
          "customer_phone": customerPhone,
          "products": products.map((product) => product.toJson()).toList(),
          "old_products":
              oldProducts.map((product) => product.toJson()).toList()
        }),
        headers: <String, String>{'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        salesProvider.resetSales();
        navigatorKey.currentState!
            .pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);

        // Push OrdersScreen on top of the navigation stack
        navigatorKey.currentState!.pushNamed(SalesScreen.routeName);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(
          title: internalError,
          message: unknownError,
          contentType: ContentType.warning);
      return false;
    }
  }

  Future<bool> deleteSoldProduct({
    required BuildContext context,
    required String salesId,
  }) async {
    String internalError = AppLocalizations.of(context)!.internalError;
    String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;
    final user = Provider.of<UserProvider>(context, listen: false).user;

    try {
      http.Response response = await http.post(
        Uri.parse("$hostedUrl/prod/sales/deleteSales"),
        body: jsonEncode(
            {"session_token": user.sessionToken, "sales_id": salesId}),
        headers: <String, String>{'Content-Type': 'application/json'},
      );

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
      return false;
    }
  }
}
