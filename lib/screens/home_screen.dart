import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grit_qr_scanner/features/products/screens/add_product_screen.dart';
import 'package:grit_qr_scanner/features/products/screens/sold_items_screen.dart';
import 'package:grit_qr_scanner/features/products/screens/view_inventory_screen.dart';
import 'package:grit_qr_scanner/utils/error_page.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:remixicon/remixicon.dart';

import '../utils/widgets/custom_card.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home-screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String menuIcon = 'assets/icons/solar_hamburger-menu-broken.svg';
  final String avatar = 'assets/images/avtar.svg';
  List<String> cardsText = [
    "Add Product",
    "View Product",
    "Sales Report",
    "Inventory",
    "Sold Items"
  ];

  List<Widget> cardsIcon = [
    const Icon(
      Remix.add_line,
      size: 30,
      color: Colors.white,
    ),
    const ImageIcon(
      AssetImage(
        'assets/icons/view-product.png',
      ),
      size: 30,
      color: Colors.white,
    ),
    const Icon(
      Remix.file_chart_line,
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
    )
  ];

  void onCardsTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, AddProductScreen.routeName);
        break;
        
      case 3:
        Navigator.pushNamed(context, ViewInventoryScreeen.routeName);
        break;

      case 4:
        Navigator.pushNamed(context, SoldItemsScreen.routeName);
        break;

      default:
        Navigator.pushNamed(context, ErrorPage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: blueColor,
      drawer: const Drawer(),
      appBar: AppBar(
        backgroundColor: blueColor,
        leading: IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            menuIcon,
            // ignore: deprecated_member_use
            color: Colors.white,
          ),
        ),
        title: const Text(
          "GRIT",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
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
    );
  }
}