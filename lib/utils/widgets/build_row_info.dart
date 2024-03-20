import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../global_variables.dart';

Widget buildInfoRow(String label, String value, {bool isPrice = false}) {
  var myGroup = AutoSizeGroup();
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 15),
        child: AutoSizeText(
          label,
          maxLines: 1,
          group: myGroup,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
        ),
      ),
      Flexible(
        child: AutoSizeText(
          value,
          group: myGroup,
          textAlign: TextAlign.end,
          style: TextStyle(
            fontSize: 16.0,
            color: blueColor,
            fontWeight: isPrice ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    ],
  );
}
