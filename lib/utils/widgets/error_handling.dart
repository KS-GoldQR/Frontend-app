import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
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
      showSnackBar(title: 'Not Found', message: jsonDecode(response.body)['error'], contentType: ContentType.warning);
      break;

    case 500:
      showSnackBar(title: 'Error', message: jsonDecode(response.body)['error'], contentType: ContentType.failure);
      break;

    default:
      showSnackBar(title: 'Failed', message: 'Invalid Move', contentType: ContentType.help);
  }
}
