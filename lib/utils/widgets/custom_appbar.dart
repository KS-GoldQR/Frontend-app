import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon:const Icon(Remix.menu_2_fill),
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
