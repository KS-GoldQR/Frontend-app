import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/features/products/screens/edit_product_screen.dart';
import 'package:grit_qr_scanner/provider/product_provider.dart';
import 'package:grit_qr_scanner/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../models/product_model.dart';
import '../../../utils/widgets/custom_appbar.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../utils/global_variables.dart';
import '../services/product_detail_card.dart';

class AboutProduct extends StatefulWidget {
  static const String routeName = '/about-product-screen';
  final Map<String, dynamic> args;
  const AboutProduct({super.key, required this.args});

  @override
  State<AboutProduct> createState() => _AboutProductState();
}

class _AboutProductState extends State<AboutProduct> {
  final String menuIcon = 'assets/icons/solar_hamburger-menu-broken.svg';
  final String avatar = 'assets/images/avtar.svg';
  Product? product;
  int currentIndex = 0;

  final String productDescription =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
      "Sed do eiusmod tempor incididunt ut";

  Future<void> _onWillPop() async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.rightSlide,
      title: 'Want to scan again?',
      desc: 'All progress will disappear',
      btnOkText: 'Yes',
      btnCancelText: 'No',
      btnOkColor: blueColor,
      btnCancelColor: blueColor,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        widget.args['callback']();
        Navigator.pop(context);
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    if (user.sessionToken.isEmpty) {
      product = widget.args['product'];
    } else {
      product = Provider.of<ProductProvider>(context).currentProduct;
    }
    // debugPrint(product!.stone_price.toString());
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => _onWillPop(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(
            double.infinity,
            MediaQuery.sizeOf(context).height * 0.06,
          ),
          child: CustomAppbar(
            menuIcon: menuIcon,
            avatar: avatar,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Product Info",
                  style: TextStyle(
                    color: blueColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(10), // Add some spacing
                SingleChildScrollView(
                  child: Text(
                    productDescription,
                    textAlign:
                        TextAlign.justify, // Your full product description here
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                const Gap(10), // Add some spacing
                SizedBox(
                  height: 200,
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: product!.image!,
                      fit: BoxFit.contain,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) =>
                          const Text("error getting image!"),
                    ),
                  ),
                ),
                const Gap(10),
                ProductDetail(label: 'Product Name: ', value: product!.name!),
                ProductDetail(label: 'Type: ', value: product!.productType!),
                ProductDetail(
                    label: 'Weight: ', value: "${product!.weight!} gm"),
                ProductDetail(label: 'Stone: ', value: product!.stone!),
                // product!.stone_price!.toString()
                ProductDetail(
                    label: 'Stone Price: ',
                    value: product!.stone_price.toString()),
                ProductDetail(
                    label: 'Jyala: ', value: product!.jyala!.toString()),
                ProductDetail(
                    label: 'Jarti: ', value: product!.jarti!.toString()),
                const ProductDetail(
                    label: 'Price: ', value: "to be calculated"),
                const Gap(20),

                if (user.sessionToken.isNotEmpty) ...[
                  CustomButton(
                    onPressed: () {},
                    text: "Sell Item",
                    backgroundColor: blueColor,
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    iconPath: 'assets/icons/material-symbols_sell.svg',
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: CustomButton(
                          onPressed: () => Navigator.pushNamed(
                              context, EditProductScreen.routeName,
                              arguments: {
                                'product': product,
                                'fromAboutProduct': true,
                              }),
                          text: "Edit Item",
                          iconColor: blueColor,
                          textColor: blueColor,
                          iconPath: 'assets/icons/bx_edit.svg',
                          fontSize: 15,
                        ),
                      ),
                      const Gap(5),
                      Expanded(
                        child: CustomButton(
                          onPressed: () {},
                          text: "Delete Item",
                          iconColor: blueColor,
                          textColor: blueColor,
                          fontSize: 15,
                          iconPath: 'assets/icons/ic_round-delete.svg',
                        ),
                      ),
                    ],
                  )
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
