import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/user_model.dart';
import '../../../provider/product_provider.dart';
import '../../../provider/user_provider.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/utils.dart';
import '../../../utils/widgets/error_handling.dart';
import '../../home/screens/home_screen.dart';
import '../screens/login_screen.dart';

class UserService {
  Future<void> userLogin(
      String phoneNo, String password, BuildContext context) async {
    String internalError = AppLocalizations.of(context)!.internalError;
    String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;

    try {
      http.Response response = await http.post(
        Uri.parse('$hostedUrl/prod/users/login'),
        body: jsonEncode({
          'phoneNo': phoneNo,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        httpErrorHandle(
            response: response,
            onSuccess: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString(
                  'session-token', jsonDecode(response.body)['sessionToken']);

              // ignore: use_build_context_synchronously
              bool isValidated = await validateSession(context);

              if (isValidated) {
                navigatorKey.currentState!.pushNamedAndRemoveUntil(
                    HomeScreen.routeName, (route) => false);
              }
            });
      } else {
        showSnackBar(
            title: "Unauthorized",
            message: jsonDecode(response.body)['message'],
            contentType: ContentType.warning);
      }
    } catch (e) {
      showSnackBar(
          title: internalError,
          message: unknownError,
          contentType: ContentType.warning);
    }
  }

  Future<bool> validateSession(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('session-token');

      if (token == null) return false;

      http.Response response = await http.post(
        Uri.parse('$hostedUrl/prod/users/validateSession'),
        body: jsonEncode({"sessionToken": token}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        httpErrorHandle(
            response: response,
            onSuccess: () async {
              String endsAtString = jsonDecode(response.body)['ends_at'];
              DateTime endsAt = DateTime.parse(endsAtString);

              User updatedUser = userProvider.user.copyWith(
                userId: jsonDecode(response.body)['user_id'],
                sessionToken: token,
                name: jsonDecode(response.body)['name'],
                phoneNo: jsonDecode(response.body)['phone'],
                appVersion: jsonDecode(response.body)['app_version'],
                subscriptionEndsAt: endsAt,
              );

              userProvider.setUserFromModel(updatedUser);
              debugPrint("user token is $token");
            });

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> userLogout({required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    String internalError = AppLocalizations.of(context)!.internalError;
    String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;
    try {
      http.Response response = await http.post(
        Uri.parse('$hostedUrl/prod/users/logout'),
        body: jsonEncode({
          "sessionToken": userProvider.user.sessionToken,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      httpErrorHandle(
          response: response,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.remove('session-token');

            userProvider.removeUser();
            productProvider.resetCurrentProduct();

            navigatorKey.currentState!.pushNamedAndRemoveUntil(
                LoginScreen.routeName, (route) => false);
          });
    } catch (e) {
      showSnackBar(
          title: internalError,
          message: unknownError,
          contentType: ContentType.warning);
    }
  }
}
