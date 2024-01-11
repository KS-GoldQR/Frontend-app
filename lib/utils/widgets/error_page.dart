import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:lottie/lottie.dart';

class ErrorPage extends StatelessWidget {
  static const String routeName = '/error-page';
  final String message;
  const ErrorPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/icons/error_animation.json',
            animate: true,
            repeat: true,
            reverse: false,
            width: size.width * 0.5,
          ),
          Text(
            message,
            style: const TextStyle(
              fontSize: 15,
              color: blueColor,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ));
  }
}
