import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:remixicon/remixicon.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
    required this.menuIcon,
  });

  final String menuIcon;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: SvgPicture.asset(menuIcon,
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn)),
      ),
      actions: const [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Icon(
            Remix.user_line,
            size: 40,
          ),
        ),
        SizedBox(
          width: 30,
        ),
      ],
    );
  }
}
