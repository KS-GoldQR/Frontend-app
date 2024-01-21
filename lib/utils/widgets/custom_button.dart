
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../global_variables.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  String? iconPath;
  Icon? icon;
  final String text;
  Color? iconColor;
  final Color textColor;
  double fontSize;
  Color? backgroundColor;
  CustomButton({
    Key? key,
    required this.onPressed,
    this.iconPath,
    this.icon,
    required this.text,
    this.backgroundColor,
    this.iconColor,
    required this.textColor,
    this.fontSize = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        side: const BorderSide(
          color: blueColor,
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(icon!=null)
            icon!,
          if (iconPath != null)
            SvgPicture.asset(
              iconPath!,
              colorFilter: ColorFilter.mode(iconColor!, BlendMode.srcIn),
            ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}