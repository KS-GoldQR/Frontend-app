import 'package:flutter/material.dart';
import 'env.dart';

String hostedUrl = Env.hostedUrl;
String s3ImageUrl = Env.s3ImageUrl;
String cacheGetOrders = "API_GetOrders";
String cacheGetSales = "API_GetSales";
String cacheGetInventory = "API_GetInventory";
String cacheGetOldProducts = "API_GetOldProducts";

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Map<String, double> goldRates = {};
DateTime lastUpdated = DateTime.now();

const Color greyColor = Color(0xFF444242);
const Color blueColor = Color(0xFF276080);
const Color formBorderColor = Color(0xFF828080);

enum ContentType{
  failure, 
  success, 
  help,
  warning
}