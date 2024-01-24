import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'global_variables.dart';

void showSnackBar(
    {required String title,
    required String message,
    required ContentType contentType}) {
  final SnackBar snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    dismissDirection: DismissDirection.horizontal,
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: contentType,
      inMaterialBanner: true,
      color: contentType == ContentType.success
          ? Colors.green
          : contentType == ContentType.failure
              ? Colors.red
              : contentType == ContentType.warning
                  ? Colors.red
                  : blueColor,
    ),
  );
  snackbarKey.currentState?.showSnackBar(snackBar);
}

Future<File?> pickFile(BuildContext context, ImageSource source) async {
  File? image;
  try {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 20,
    );

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(
        title: "Error Occurred",
        message: e.toString(),
        contentType: ContentType.failure);
  }
  return image!;
}

Future<List<File>> pickFiles(BuildContext context) async {
  List<File> files = [];
  try {
    final pickedFiles = await ImagePicker().pickMultiImage(
      imageQuality: 20,
    );
    if (pickedFiles.isNotEmpty) {
      for (int i = 0; i < pickedFiles.length; i++) {
        files.add(File(pickedFiles[i].path));
      }
    }
  } catch (e) {
    showSnackBar(
        title: 'Error Occurred',
        message: e.toString(),
        contentType: ContentType.failure);
  }
  return files;
}

TextStyle customTextDecoration() {
  return const TextStyle(
    color: Color(0xFF282828),
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );
}

InputDecoration customTextfieldDecoration() {
  return const InputDecoration(
    isDense: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFC3C3C3),
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFC3C3C3),
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFFC3C3C3),
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    ),
  );
}

Future<Map<String, double>> getRate() async {
  Map<String, double> goldRates = {};
  try {
    http.Response response = await http.post(
        Uri.parse("$hostedUrl/prod/users/getGoldRate"),
        headers: {"Content-Type": "application/json"});

    Map<String, dynamic> jsonData = json.decode(response.body);
    Map<String, String> rawRates = Map<String, String>.from(jsonData['rate']);

    debugPrint(rawRates.toString());

    rawRates.forEach((key, value) {
      if (key == "cgold_10gram") {
        goldRates["Chapawala"] = double.parse(value) / 10;
      } else if (key == "tgold_10gram") {
        goldRates["Tejabi"] = double.parse(value) / 10;
      } else if (key == "achandi_10gram") {
        goldRates["Asal_Chaadhi"] = double.parse(value) / 10;
        debugPrint(goldRates["Asal_Chaadhi"].toString());
      }
    });
  } catch (e) {
    showSnackBar(
        title: "Error",
        message: "error fethching gold rates",
        contentType: ContentType.warning);
  }

  lastUpdated = DateTime.now();

  debugPrint(goldRates.toString());
  return goldRates;
}

double getWeight(double weight, String selectedWeightType) {
  double result;

  if (selectedWeightType == "Tola") {
    result = weight * 11.664;
  } else if (selectedWeightType == "Laal") {
    result = weight * 0.1166;
  } else {
    result = weight;
  }

  return double.parse(result.toStringAsFixed(3));
}

double getWeightByType(double weight, String selectedWeightType) {
  double result;

  if (selectedWeightType == "Tola") {
    result = weight / 11.664;
  } else if (selectedWeightType == "Laal") {
    result = weight / 0.1166;
  } else {
    result = weight;
  }

  return double.parse(result.toStringAsFixed(3));
}

double getTotalPrice(
    {required double weight,
    required double rate,
    required double? jyalaPercent,
    required double? jartiPercent,
    required double stonePrice}) {
  double itemPrice = weight * rate;

  double jyala = jyalaPercent == null ? 0.0 : (itemPrice * jyalaPercent);
  double jarti = jartiPercent == null ? 0.0 : (itemPrice * jartiPercent);
  double result = itemPrice + jyala + jarti + stonePrice;
  return double.parse(result.toStringAsFixed(3));
}
