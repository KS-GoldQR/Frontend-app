import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/features/auth/screens/login_screen.dart';
import 'package:grit_qr_scanner/models/user_model.dart';
import 'package:grit_qr_scanner/provider/user_provider.dart';
import 'package:grit_qr_scanner/features/home/screens/home_screen.dart';
import 'package:grit_qr_scanner/utils/widgets/error_handling.dart';
import 'package:grit_qr_scanner/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../provider/product_provider.dart';
import '../../../utils/global_variables.dart';

class UserService {
  Future<void> userLogin(
      String phoneNo, String password, BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

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

              showSnackBar(
                  title: "Success",
                  message: "successfully logged in",
                  contentType: ContentType.success);
              navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  HomeScreen.routeName, (route) => false);
              User user = User(
                  userId: jsonDecode(response.body)['userId'],
                  phoneNo: phoneNo,
                  password: password,
                  sessionToken: jsonDecode(response.body)['sessionToken']);

              userProvider.setUserFromModel(user);
            });
      } else {
        debugPrint(response.body.toString());
        showSnackBar(
            title: "Error",
            message: jsonDecode(response.body)['message'],
            contentType: ContentType.failure);
      }
    } catch (e) {
      showSnackBar(
          title: "Internal Error",
          message: "an unknown error occurred",
          contentType: ContentType.warning);
      debugPrint(e.toString());
    }
  }

  Future<bool> validateSession(BuildContext context) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('session-token');

      if (token == null) return false;
      debugPrint(token);

      http.Response response = await http.post(
        Uri.parse('$hostedUrl/prod/users/validateSession'),
        body: jsonEncode({"sessionToken": token}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String endsAtString = jsonDecode(response.body)['ends_at'];
        DateTime endsAt = DateTime.parse(endsAtString);

        User updatedUser = userProvider.user.copyWith(
          userId: jsonDecode(response.body)['user_id'],
          sessionToken: token,
          name: jsonDecode(response.body)['name'],
          phoneNo: jsonDecode(response.body)['phone'],
          subscriptionEndsAt: endsAt,
        );

        userProvider.setUserFromModel(updatedUser);
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

      debugPrint(response.statusCode.toString());

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('session-token');

        userProvider.removeUser();
        productProvider.resetCurrentProduct();

        showSnackBar(
            title: "Success",
            message: "successfully logged out",
            contentType: ContentType.success);
        navigatorKey.currentState!
            .pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
      } else {
        debugPrint(response.body.toString());
        showSnackBar(
            title: "Error",
            message: jsonDecode(response.body)['message'],
            contentType: ContentType.failure);
      }
    } catch (e) {
      showSnackBar(
          title: "Internal Error",
          message: "an unknown error occurred",
          contentType: ContentType.warning);
      debugPrint(e.toString());
    }
  }
}
