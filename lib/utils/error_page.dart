import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  static const String routeName = '/error-page';
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Error"),
      ),
    );
  }
}
