import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import 'global_variables.dart';

InputDecoration passwordDecoration(
    {required VoidCallback onPressed, required bool isVisible, required String hintText}) {
  return InputDecoration(
    isDense: true,
    contentPadding: const EdgeInsets.all(10),
    hintText: hintText,
    hintStyle: const TextStyle(
      color: Color(0xFFCBC8C8),
      fontSize: 16,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w400,
    ),
    suffixIcon: IconButton(
      onPressed: onPressed,
      icon: Icon(isVisible ? Remix.eye_line : Remix.eye_off_line),
    ),
    border: const OutlineInputBorder(
      borderSide: BorderSide(
        color: formBorderColor,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: formBorderColor,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: formBorderColor,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  );
}

InputDecoration userIdDecoration({required String hintText}) {
  return  InputDecoration(
    isDense: true,
    contentPadding: const EdgeInsets.all(10),
    hintText: hintText,
    hintStyle: const TextStyle(
        color: Color(0xFFCBC8C8),
        fontSize: 16,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w400),
    border: const OutlineInputBorder(
      borderSide: BorderSide(
        color: formBorderColor,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: formBorderColor,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: formBorderColor,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  );
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
