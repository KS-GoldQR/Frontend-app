import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'global_variables.dart';

void showSnackBar(String text) {
  final SnackBar snackBar = SnackBar(content: Text(text));
  snackbarKey.currentState?.showSnackBar(snackBar);
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

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
    showSnackBar( "from utils file of pickfiles func $e");
  }
  return files;
}
