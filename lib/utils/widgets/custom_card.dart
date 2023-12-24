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
    final size = MediaQuery.sizeOf(context);
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
            height: (size.height / 3) * 0.2,
            width: size.width * 0.15,
            decoration: BoxDecoration(
              color: blueColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: icon),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
