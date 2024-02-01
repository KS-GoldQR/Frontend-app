import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
 const Loader({super.key, required this.circularIndicatiorKey});
  final GlobalKey circularIndicatiorKey;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        key: circularIndicatiorKey,
      ),
    );
  }
}
