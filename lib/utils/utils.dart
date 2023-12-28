import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'global_variables.dart';

void showSnackBar(String text) {
  final SnackBar snackBar = SnackBar(content: Text(text));
  snackbarKey.currentState?.showSnackBar(snackBar);
}


Future<File?> pickFile(BuildContext context, ImageSource source) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: source, imageQuality: 20,);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(e.toString());
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
    showSnackBar( "Error occurred $e");
  }
  return files;
}

  TextStyle customTextDecoration() {
    return const TextStyle(
      color: Color(0xFF282828),
      fontSize: 15,
      fontWeight: FontWeight.w400,
      fontFamily: 'Inter',
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

