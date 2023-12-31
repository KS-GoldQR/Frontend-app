import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/models/user_model.dart';
import 'package:grit_qr_scanner/provider/user_provider.dart';
import 'package:grit_qr_scanner/features/home/screens/home_screen.dart';
import 'package:grit_qr_scanner/utils/widgets/error_handling.dart';
import 'package:grit_qr_scanner/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../utils/global_variables.dart';

class UserService {
  Future<void> userLogin(
      String userId, String password, BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      User user = User(userId: "", password: "", sessionToken: "");
      http.Response response = await http.post(
        Uri.parse('$hostedUrl/login'),
        body: jsonEncode({
          'phoneNo': userId,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      // debugPrint(jsonDecode(response.body)['sessionToken']);
      debugPrint(hostedUrl);

      if (response.statusCode == 200) {
        httpErrorHandle(
            response: response,
            onSuccess: () {
              showSnackBar(
                  title: "Success",
                  message: "successfully logged in",
                  contentType: ContentType.success);
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
        debugPrint(response.body.toString());
        showSnackBar(
            title: "Error",
            message: jsonDecode(response.body)['message'],
            contentType: ContentType.failure);
      }
    } catch (e) {
      showSnackBar(
          title: "Internal Error",
          message: e.toString(),
          contentType: ContentType.warning);
      debugPrint(e.toString());
    }
  }
}
