import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/features/products/screens/edit_product_screen.dart';
import 'package:grit_qr_scanner/features/products/widgets/customer_details_form.dart';
import 'package:grit_qr_scanner/provider/product_provider.dart';
import 'package:grit_qr_scanner/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../models/product_model.dart';
import '../../../utils/utils.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../utils/global_variables.dart';
import '../widgets/product_detail_card.dart';

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

  void navigateToCustomerDetailsForm(BuildContext context, String productId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomerDetailsForm(productId: productId)));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    if (user.sessionToken.isEmpty) {
      product = widget.args['product'];
    } else {
      product = Provider.of<ProductProvider>(context).currentProduct;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Product"),
        centerTitle: false,
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
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
              ),
              const Gap(10),
              ProductDetail(label: 'Product Name: ', value: product!.name!),
              ProductDetail(label: 'Type: ', value: product!.productType!),
              ProductDetail(label: 'Weight: ', value: "${product!.weight!} gm"),
              ProductDetail(label: 'Stone: ', value: product!.stone!),
              ProductDetail(
                  label: 'Stone Price: ',
                  value: product!.stone_price.toString()),
              ProductDetail(label: 'Jyala: ', value: " ${product!.jyala!}%"),
              ProductDetail(label: 'Jarti: ', value: "${product!.jarti!}%"),
              ProductDetail(
                  label: 'Price: ',
                  value: getTotalPrice(
                          weight: product!.weight!,
                          rate: 1000,
                          jyalaPercent: product!.jyala!,
                          jartiPercent: product!.jarti,
                          stonePrice: product!.stone_price!)
                      .toString()),
              const Gap(20),

              if (user.sessionToken.isNotEmpty) ...[
                CustomButton(
                  onPressed: () =>
                      navigateToCustomerDetailsForm(context, product!.id),
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
    );
  }
}
