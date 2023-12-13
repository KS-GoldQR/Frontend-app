import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginLowerDesign extends StatelessWidget {
  const LoginLowerDesign({super.key});

  final String ellipse1 = 'assets/images/Ellipse1.svg';
  final String ellipse2 = 'assets/images/Ellipse2.svg';
  final String ellipse3 = 'assets/images/Ellipse3.svg';
  final String ellipse4 = 'assets/images/Ellipse4.svg';

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: SvgPicture.asset(
                ellipse2,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SvgPicture.asset(
                ellipse3,
              ),
            ),
          ],
        ),
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: SvgPicture.asset(
                ellipse1,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: SvgPicture.asset(
                ellipse4,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
