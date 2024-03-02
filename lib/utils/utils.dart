import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
  String internalError = AppLocalizations.of(context)!.internalError;
  String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;
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
        title: internalError,
        message: unknownError,
        contentType: ContentType.warning);
  }
  return image!;
}

Future<List<File>> pickFiles(BuildContext context) async {
  String internalError = AppLocalizations.of(context)!.internalError;
  String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;
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
        title: internalError,
        message: unknownError,
        contentType: ContentType.warning);
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

Future<void> getRate(BuildContext context) async {
  String internalError = AppLocalizations.of(context)!.internalError;
  String unknownError = AppLocalizations.of(context)!.unknownErrorOccurred;
  try {
    http.Response response = await http.post(
        Uri.parse("$hostedUrl/prod/users/getGoldRate"),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      Map<String, dynamic> rawRates = json.decode(response.body);
      //  //date is null so not implemented

      rawRates.forEach((key, value) {
        if (key == "Chappawala") {
          goldRates["Chhapawal"] = double.parse(value);
        } else if (key == "Tejabi") {
          goldRates["Tejabi"] = double.parse(value);
        } else if (key == "Asal") {
          goldRates["Asal Chandi"] = double.parse(value);
        }
      });
      lastUpdated = DateTime.now();
      return;
    } else {
      return;
    }
  } catch (e) {
    showSnackBar(
        title: internalError,
        message: unknownError,
        contentType: ContentType.warning);
  }
}

//return weight from any type to grams
double getWeightInGram(double weight, String selectedWeightType) {
  double result;

  if (selectedWeightType == "Tola") {
    result = weight * 11.664;
  } else if (selectedWeightType == "Laal") {
    result = weight * 0.11664;
  } else {
    result = weight;
  }

  return double.parse(result.toStringAsFixed(3));
}

//return weight in given type
double getWeightInType(double weight, String selectedWeightType) {
  //by default whatever weight is passed in this function is in gram, because its from api and in api weight is converted to gram and stored
  double result;
  if (selectedWeightType == "Tola") {
    result = weight / 11.664;
  } else if (selectedWeightType == "Laal") {
    result = weight / 0.11664;
  } else {
    result = weight;
  }

  return double.parse(result.toStringAsFixed(3));
}

double getTotalPrice(
    {required double weight,
    required double rate,
    String? jartiWeightType,
    double? loss,
    double? charge,
    double? jyala,
    double? jarti,
    double? stonePrice}) {
  double itemPrice = (weight - (loss ?? 0.0)) * rate;
  double modifiedJarti = jarti == null
      ? 0.0
      : jartiWeightType == "Laal"
          ? getWeightInGram(jarti, "Laal") * rate
          : itemPrice * (jarti / 100);

  double result = itemPrice +
      (jyala ?? 0.0) +
      modifiedJarti +
      (stonePrice ?? 0.0) -
      (charge ?? 0.0);
  return double.parse(result.toStringAsFixed(3));
}

String formatDateTime(DateTime date) {
  final dateTime = DateTime(date.year, date.month, date.day);
  return DateFormat.yMMMMd().format(dateTime);
}

String formatDateTimeRange(DateTime date) {
  final dateTime = DateTime(date.year, date.month, date.day);
  return DateFormat('d MMM y').format(dateTime);
}

(String?, String?, String?) translatedTypes({
  required BuildContext context,
  String? selectedWeightType,
  String? selectedProductType,
  String? selectedJartiWeightType,
}) {
  String countryLanguageUsed = Localizations.localeOf(context).countryCode!;
  if (countryLanguageUsed == "NP") {
    String? rselectedWeightType = selectedWeightType == "ग्राम"
        ? "Gram"
        : selectedWeightType == "तोला"
            ? "Tola"
            : "Laal";

    String? rselectedProductType = selectedProductType == "छापावाल"
        ? "Chhapawal"
        : selectedProductType == "तेजाबी"
            ? "Tejabi"
            : "Asal Chandi";

    String? rselectedJartiWeightType =
        selectedJartiWeightType == "लाल" ? "Laal" : "%";

    return (
      rselectedWeightType,
      rselectedProductType,
      rselectedJartiWeightType
    );
  }
  return (selectedWeightType, selectedProductType, selectedJartiWeightType);
}

String getNumberFormat(dynamic value) {
  return NumberFormat('#,##,###.00').format(value);
}

List<String> getJartiWeightType(BuildContext context) {
  List<String> weight = [
    AppLocalizations.of(context)!.laal,
    AppLocalizations.of(context)!.percentage,
  ];

  return weight;
}
