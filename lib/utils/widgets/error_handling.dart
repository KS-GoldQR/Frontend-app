import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
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

    case 201: // Created
      onSuccess();
      break;

    case 204: // No Content
      onSuccess();
      break;

    case 400:
      showSnackBar(
          title: 'Bad Request',
          message: jsonDecode(response.body)['message'],
          contentType: ContentType.warning);
      navigatorKey.currentState!.pop();
      break;

    case 401: // Unauthorized
      showSnackBar(
          title: 'Unauthorized',
          message: jsonDecode(response.body)['message'],
          contentType: ContentType.warning);
      navigatorKey.currentState!.pop();
      break;

    case 403: // Forbidden
      showSnackBar(
          title: 'Forbidden',
          message: jsonDecode(response.body)['message'],
          contentType: ContentType.warning);
      navigatorKey.currentState!.pop();
      break;

    case 404:
      showSnackBar(
          title: 'Not Found',
          message: jsonDecode(response.body)['message'],
          contentType: ContentType.warning);
      navigatorKey.currentState!.pop();
      break;

    case 409: // Conflict
      showSnackBar(
          title: 'Conflict',
          message: jsonDecode(response.body)['message'],
          contentType: ContentType.warning);
      navigatorKey.currentState!.pop();
      break;

    case 422: // Unprocessable Entity
      showSnackBar(
          title: 'Unprocessable Entity',
          message: jsonDecode(response.body)['message'],
          contentType: ContentType.warning);
      navigatorKey.currentState!.pop();
      break;

    case 500:
      showSnackBar(
          title: 'Internal Server Error',
          message: jsonDecode(response.body)['message'],
          contentType: ContentType.failure);
      break;

    case 502: // Bad Gateway
      showSnackBar(
          title: 'Bad Gateway',
          message: 'The server received an invalid response from an inbound server it accessed while attempting to fulfill the request.',
          contentType: ContentType.failure);
      break;

    case 503: // Service Unavailable
      showSnackBar(
          title: 'Service Unavailable',
          message: 'The server is not ready to handle the request.',
          contentType: ContentType.failure);
      break;

    default:
      showSnackBar(
          title: 'Failed',
          message: 'An unknown error occurred',
          contentType: ContentType.help);
  }
}
