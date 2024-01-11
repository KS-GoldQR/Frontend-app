import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
    required this.menuIcon,
    required this.avatar,
  });

  final String menuIcon;
  final String avatar;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: SvgPicture.asset(
          menuIcon,
          colorFilter:const ColorFilter.mode(Colors.black, BlendMode.srcIn)
        ),
      ),
      actions: [
        CircleAvatar(
          radius: 20,
          child: SvgPicture.asset(
            avatar,
            fit: BoxFit.contain,
            height: 55,
          ),
        ),
        const SizedBox(
          width: 30,
        ),
      ],
    );
  }
}
