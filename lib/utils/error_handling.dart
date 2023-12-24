import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/utils/utils.dart';
import 'package:http/http.dart' as http;

void httpErrorHandle({
  required http.Response response,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;

    case 400:
      showSnackBar(jsonDecode(response.body)['msg']);
      break;

    case 500:
      showSnackBar(jsonDecode(response.body)['error']);
      break;

    default:
      showSnackBar(response.body);
  }
}
