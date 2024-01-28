import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grit_qr_scanner/features/auth/services/user_service.dart';
import 'package:grit_qr_scanner/features/home/screens/calculator_screen.dart';
import 'package:grit_qr_scanner/features/home/screens/gold_rates_screen.dart';
import 'package:grit_qr_scanner/features/home/screens/user_details_screen.dart';
import 'package:grit_qr_scanner/features/orders/screens/order_screen.dart';
import 'package:grit_qr_scanner/features/products/screens/view_inventory_screen.dart';
import 'package:grit_qr_scanner/features/home/screens/qr_scanner_screen.dart';
import 'package:grit_qr_scanner/features/home/widgets/custom_drawer.dart';
import 'package:grit_qr_scanner/utils/widgets/error_page.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../utils/widgets/custom_card.dart';
import '../../sales/screens/sold_items_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home-screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService _userService = UserService();
  bool isLoggingOut = false;

  List<String> cardsText = [];

  List<Widget> cardsIcon = [
    const Icon(
      Remix.qr_code_line,
      size: 30,
      color: Colors.white,
    ),
    const Icon(
      Remix.store_2_line,
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
    const Icon(
      Remix.money_dollar_box_line,
      size: 30,
      color: Colors.white,
    ),
    const Icon(
      Remix.calculator_line,
      size: 30,
      color: Colors.white,
    )
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
        Navigator.pushNamed(context, OrderScreen.routeName);
        break;

      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GoldRatesScreen()),
        );

      case 5:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CalculatorScreen()));

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
  void didChangeDependencies() {
    cardsText = [
      AppLocalizations.of(context)!.scanQR,
      AppLocalizations.of(context)!.inventory,
      AppLocalizations.of(context)!.soldItems,
      AppLocalizations.of(context)!.orders,
      AppLocalizations.of(context)!.rates,
      AppLocalizations.of(context)!.calculator,
    ];
    super.didChangeDependencies();
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
        key: scaffoldKey,
        backgroundColor: blueColor,
        drawer: const CustomDrawer(),
        appBar: AppBar(
          backgroundColor: blueColor,
          leading: GestureDetector(
            onTap: () {
              scaffoldKey.currentState?.openDrawer(); // Open drawer directly
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Remix.menu_2_fill,
              ),
            ),
          ),
          title: const Text(
            "Smart Sunar",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: userLogout,
              icon: const Icon(
                Remix.logout_box_r_line,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Remix.settings_3_line,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.dashboard,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "${AppLocalizations.of(context)!.lastUpdate}: ${DateFormat.yMMMd().format(lastUpdated)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () => navigatorKey.currentState!
                        .pushNamed(UserDetailsScreen.routeName),
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Remix.user_line,
                        size: 40,
                      ),
                    ),
                  ),
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
                      crossAxisSpacing: 5,
                      childAspectRatio: size.width / (size.height / 1.8),
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
