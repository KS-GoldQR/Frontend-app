import 'package:flutter/material.dart';

import '../global_variables.dart';

class CustomCard extends StatelessWidget {
  final String text;
  final Widget icon;
  const CustomCard({
    super.key,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shadowColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: blueColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: icon,
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
