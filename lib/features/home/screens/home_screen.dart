import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:remixicon/remixicon.dart';

import '../../../utils/global_variables.dart';
import '../../../utils/widgets/custom_card.dart';
import '../../../utils/widgets/error_page.dart';
import '../../auth/services/user_service.dart';
import '../../old%20products/screens/old_product_screen.dart';
import '../../orders/screens/order_screen.dart';
import '../../products/screens/view_inventory_screen.dart';
import '../../sales/screens/sales_screen.dart';
import '../widgets/custom_drawer.dart';
import 'calculator_screen.dart';
import 'gold_rates_screen.dart';
import 'qr_scanner_screen.dart';
import 'user_details_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home-screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService _userService = UserService();
  final GlobalKey _modalProgressHUDKeyHomeScreen = GlobalKey();
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
    ),
    const Icon(
      Remix.safe_2_line,
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

      //due to requirement change, sales details are avoided my be needed in future, just uncomment and adjust indexes
      case 2:
        Navigator.pushNamed(context, SalesScreen.routeName);
        break;

      case 3:
        Navigator.pushNamed(context, OrderScreen.routeName);
        break;

      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GoldRatesScreen()),
        );
        break;

      case 5:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CalculatorScreen()));
        break;

      case 6:
        Navigator.pushNamed(context, OldProductsScreen.routeName);
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
  void didChangeDependencies() {
    cardsText = [
      AppLocalizations.of(context)!.scanQR,
      AppLocalizations.of(context)!.inventory,
      AppLocalizations.of(context)!.soldItems,
      AppLocalizations.of(context)!.orders,
      AppLocalizations.of(context)!.rates,
      AppLocalizations.of(context)!.calculator,
      AppLocalizations.of(context)!.deposit,
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return ModalProgressHUD(
      inAsyncCall: isLoggingOut,
      key: _modalProgressHUDKeyHomeScreen,
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
          title: Text(
            AppLocalizations.of(context)!.smartSunar,
            style: const TextStyle(
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
            // IconButton(
            //   onPressed: () {},
            //   icon: const Icon(
            //     Remix.settings_3_line,
            //   ),
            // ),
            const Gap(10),
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
