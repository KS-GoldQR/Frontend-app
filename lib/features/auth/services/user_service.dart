import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/models/user_model.dart';
import 'package:grit_qr_scanner/provider/user_provider.dart';
import 'package:grit_qr_scanner/screens/home_screen.dart';
import 'package:grit_qr_scanner/utils/error_handling.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:grit_qr_scanner/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<void> userLogin(
      String userId, String password, BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      User user = User(userId: "", password: "", sessionToken: "");
      http.Response response = await http.post(
        Uri.parse('$hostedUrl/users/login'),
        body: jsonEncode({
          'phoneNo': userId,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      debugPrint(jsonDecode(response.body)['sessionToken']);

      if (response.statusCode == 200) {
        httpErrorHandle(
            response: response,
            onSuccess: () {
              showSnackBar("Login Success");
              navigatorKey.currentState!.pushNamedAndRemoveUntil(
                  HomeScreen.routeName, (route) => false);
              user = User(
                  userId: userId,
                  password: password,
                  sessionToken: jsonDecode(response.body)['sessionToken']);

              userProvider.setUserFromModel(user);
              debugPrint("Success");
            });
      } else {
        showSnackBar("Something went wrong! here");
      }
    } catch (e) {
      showSnackBar("Server side error, $e");
      debugPrint(e.toString());
    }
  }
}
