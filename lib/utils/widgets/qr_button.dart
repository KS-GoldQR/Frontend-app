import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/features/home/screens/qr_scanner_screen.dart';
import 'package:remixicon/remixicon.dart';

import '../global_variables.dart';

class QrButton extends StatelessWidget {
  const QrButton({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: SizedBox(
        width: size.width * 0.5,
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, QRScannerScreen.routeName);
          },
          style: TextButton.styleFrom(
            enableFeedback: false,
            splashFactory: NoSplash.splashFactory,
            side: const BorderSide(
              color: greyColor,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Scan QR code",
                style: TextStyle(color: greyColor),
              ),
              SizedBox(width: 5),
              Icon(
                Remix.qr_code_line,
                size: 20,
                color: greyColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
