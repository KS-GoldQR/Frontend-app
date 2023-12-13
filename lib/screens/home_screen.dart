import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  ];

  List<Widget> cardsIcon = [
    const Icon(
      Remix.add_line,
      size: 50,
      color: Colors.white,
    ),
    const ImageIcon(
      AssetImage(
        'assets/icons/view-product.png',
      ),
      size: 50,
      color: Colors.white,
    ),
    const Icon(
      Remix.file_chart_line,
      size: 50,
      color: Colors.white,
    ),
    const ImageIcon(
      AssetImage('assets/icons/inventory.png'),
      size: 50,
      color: Colors.white,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      drawer: const Drawer(),
      appBar: AppBar(
        backgroundColor: blueColor,
        leading: IconButton(
          onPressed: () {},
          icon: SvgPicture.asset(
            menuIcon,
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
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: GridView.builder(
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 15),
                  itemBuilder: (context, index) {
                    return CustomCard(
                      text: cardsText[index],
                      icon: Padding(
                        padding: const EdgeInsets.all(10),
                        child: cardsIcon[index],
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
