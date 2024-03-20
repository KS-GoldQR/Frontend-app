import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:provider/provider.dart';

import '../models/sales_model.dart';
import '../provider/sales_provider.dart';
import '../provider/user_provider.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';
import '../utils/widgets/error_handling.dart';
import '../features/home/screens/home_screen.dart';
import '../features/orders/models/old_jwellery_model.dart';
import '../features/sales/models/sold_product_model.dart';
import '../features/sales/screens/sales_screen.dart';

class SalesService {
  Future<List<SalesModel>> getSales(BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    String internalError = AppLocalizations.of(context)!.internalError;
    List<SalesModel> sales = [];
    try {
      var isCacheExist =
          await APICacheManager().isAPICacheKeyExist(cacheGetSales);

      if (!isCacheExist) {
        http.Response response = await http.post(
          Uri.parse('$hostedUrl/prod/sales/viewSales'),
          body: jsonEncode({
            'session_token': user.sessionToken,
          }),
          headers: {'Content-Type': 'application/json'},
        );

        httpErrorHandle(
            response: response,
            onSuccess: () async {
              List<dynamic> salesList =
                  getModifiedSalesResponse(jsonDecode(response.body)['sales']);

              debugPrint("from api hit");
              debugPrint(salesList.toString());

              for (int i = 0; i < salesList.length; i++) {
                debugPrint("hello");
                sales.add(SalesModel.fromMap(salesList[i]));
              }

              APICacheDBModel cacheDBModel =
                  APICacheDBModel(key: cacheGetSales, syncData: response.body);
              await APICacheManager().addCacheData(cacheDBModel);
              debugPrint(sales.toString());
            });
      } else {
        debugPrint("from cache hit");
        var cacheData = await APICacheManager().getCacheData(cacheGetSales);

        List<dynamic> salesList =
            getModifiedSalesResponse(jsonDecode(cacheData.syncData)['sales']);

        for (int i = 0; i < salesList.length; i++) {
          sales.add(SalesModel.fromMap(salesList[i]));
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(title: internalError, contentType: ContentType.warning);
    }
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
        await APICacheManager().deleteCache(cacheGetSales);
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
      showSnackBar(title: internalError, contentType: ContentType.warning);
      return false;
    }
  }

  Future<bool> deleteSoldProduct({
    required BuildContext context,
    required String salesId,
  }) async {
    String internalError = AppLocalizations.of(context)!.internalError;
    final user = Provider.of<UserProvider>(context, listen: false).user;

    try {
      http.Response response = await http.post(
        Uri.parse("$hostedUrl/prod/sales/deleteSales"),
        body: jsonEncode(
            {"session_token": user.sessionToken, "sales_id": salesId}),
        headers: <String, String>{'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        await APICacheManager().deleteCache(cacheGetSales);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      showSnackBar(title: internalError, contentType: ContentType.warning);
      return false;
    }
  }

  List<dynamic> getModifiedSalesResponse(List<dynamic> salesList) {
    for (int i = 0; i < salesList.length; i++) {
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

      // Input date string
      final dateStr = salesList[i]['created_at'];

// Split the date and time components
      final dateComponents = dateStr.split(" ");
      final nepaliDateComponents = dateComponents[0].split("-");
      final timeComponents = dateComponents[1].split(":");

// Extract components
      final nepaliYear = int.parse(nepaliDateComponents[0]);
      final nepaliMonth = int.parse(nepaliDateComponents[1]);
      final nepaliDay = int.parse(nepaliDateComponents[2]);
      final hour = int.parse(timeComponents[0]);
      final minute = int.parse(timeComponents[1]);
      final second = int.parse(timeComponents[2]);

// Create a NepaliDateTime object
      final nepaliDateTime = NepaliDateTime(
          nepaliYear, nepaliMonth, nepaliDay, hour, minute, second);
      // Parse modified strings back to maps/lists
      Map<String, dynamic> rate = jsonDecode(modifiedRate);
      List<dynamic> products = jsonDecode(modifiedProducts);
      List<dynamic> oldProducts = jsonDecode(modifiedOldProducts);

      debugPrint("modified old product");
      debugPrint(oldProducts.toString());

      // Replace the original fields with parsed versions
      salesList[i]['rate'] = rate;
      salesList[i]['products'] = products;
      salesList[i]['old_products'] = oldProducts;
      salesList[i]['created_at'] = nepaliDateTime.toString();
    }

    return salesList;
  }
}
