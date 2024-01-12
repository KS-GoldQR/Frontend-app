import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grit_qr_scanner/features/auth/services/user_service.dart';
import 'package:grit_qr_scanner/features/products/screens/sold_items_screen.dart';
import 'package:grit_qr_scanner/features/products/screens/view_inventory_screen.dart';
import 'package:grit_qr_scanner/features/home/screens/qr_scanner_screen.dart';
import 'package:grit_qr_scanner/utils/widgets/error_page.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:remixicon/remixicon.dart';

import '../../../utils/widgets/custom_card.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home-screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String menuIcon = 'assets/icons/solar_hamburger-menu-broken.svg';
  final String avatar = 'assets/images/avtar.svg';
  final UserService _userService = UserService();
  bool isLoggingOut = false;

  List<String> cardsText = [
    "Scan Qr",
    "Inventory",
    "Sold Items",
    "Orders",
  ];

  List<Widget> cardsIcon = [
    const Icon(
      Remix.qr_code_line,
      size: 30,
      color: Colors.white,
    ),
    const ImageIcon(
      AssetImage('assets/icons/inventory.png'),
      size: 30,
      color: Colors.white,
    ),
    const Icon(
      Remix.product_hunt_line,
      size: 30,
      color: Colors.white,
    ),
    const Icon(
      Remix.shopping_cart_2_line,
      size: 30,
      color: Colors.white,
    ),
  ];

  void onCardsTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, QRScannerScreen.routeName);
        break;

      case 1:
        Navigator.pushNamed(context, ViewInventoryScreen.routeName);
        break;

      case 2:
        Navigator.pushNamed(context, SoldItemsScreen.routeName);
        break;

      case 3:
        Navigator.pushNamed(context, SoldItemsScreen.routeName);
        break;

      default:
        Navigator.pushNamed(context, ErrorPage.routeName);
    }
  }

  void userLogout() async {
    setState(() {
      isLoggingOut = true;
    });
    await _userService.userLogout(context: context);
    setState(() {
      isLoggingOut = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return ModalProgressHUD(
      inAsyncCall: isLoggingOut,
      blur: 0.5,
      progressIndicator: const SpinKitSquareCircle(
        color: blueColor,
        size: 70,
      ),
      child: Scaffold(
        backgroundColor: blueColor,
        drawer: const Drawer(),
        appBar: AppBar(
          backgroundColor: blueColor,
          leading: IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(menuIcon,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          ),
          title: const Text(
            "Smart Sunar",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: userLogout,
              icon: const Icon(
                Remix.logout_box_r_line,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Remix.settings_3_line,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dashboard",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Last update 15 Nov 2023",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                  CircleAvatar(
                    radius: 30,
                    child: SvgPicture.asset(
                      avatar,
                      fit: BoxFit.contain,
                      height: 55,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F4FF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
                  child: GridView.builder(
                    itemCount: cardsText.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: size.width / (size.height / 2),
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => onCardsTapped(index),
                        child: CustomCard(
                          text: cardsText[index],
                          icon: Padding(
                            padding: const EdgeInsets.all(10),
                            child: cardsIcon[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
