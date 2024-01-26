import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/features/products/screens/edit_product_screen.dart';
import 'package:grit_qr_scanner/features/products/widgets/customer_details_form.dart';
import 'package:grit_qr_scanner/provider/product_provider.dart';
import 'package:grit_qr_scanner/provider/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  Product? product;
  int currentIndex = 0;

  final String productDescription = "Description not added yet!";

  void navigateToCustomerDetailsForm(
      BuildContext context, Product product, double price) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerDetailsForm(
          product: product,
          price: price,
        ),
      ),
    );
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
        title: Text(
          AppLocalizations.of(context)!.viewProduct,
          style: const TextStyle(fontSize: 20),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.productInfo,
                style: const TextStyle(
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
              ProductDetail(
                  label: '${AppLocalizations.of(context)!.productName}: ',
                  value: product!.name!),
              ProductDetail(
                  label: '${AppLocalizations.of(context)!.type}: ',
                  value: product!.productType!),
              ProductDetail(
                  label: '${AppLocalizations.of(context)!.weight}: ',
                  value:
                      "${getWeightByType(product!.weight!, "Gram")} ${AppLocalizations.of(context)!.gram}"),
              ProductDetail(
                  label: '${AppLocalizations.of(context)!.weight}: ',
                  value:
                      "${getWeightByType(product!.weight!, "Laal")} ${AppLocalizations.of(context)!.laal}"),
              ProductDetail(
                  label: '${AppLocalizations.of(context)!.weight}: ',
                  value:
                      "${getWeightByType(product!.weight!, "Tola")} ${AppLocalizations.of(context)!.tola}"),
              ProductDetail(
                  label: '${AppLocalizations.of(context)!.stone}: ',
                  value: product!.stone!),
              ProductDetail(
                  label: '${AppLocalizations.of(context)!.stonePrice} : ',
                  value:
                      "रु${NumberFormat('#,##,###.00').format(product!.stone_price)}"),
              ProductDetail(
                  label: '${AppLocalizations.of(context)!.jyala}: ',
                  value: "${product!.jyala!}%"),
              ProductDetail(
                  label: '${AppLocalizations.of(context)!.jarti}: ',
                  value: "${product!.jarti!}%"),
              ProductDetail(
                  label: '${AppLocalizations.of(context)!.price}: ',
                  value: goldRates.isEmpty
                      ? "error fetching rate..."
                      : "रु${NumberFormat('#,##,###.00').format(getTotalPrice(weight: product!.weight!, rate: goldRates[product!.productType!]!, jyalaPercent: product!.jyala!, jartiPercent: product!.jarti, stonePrice: product!.stone_price!))}"),
              const Gap(20),

              if (product!.validSession == "1" || widget.args['fromInventory'])
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, EditProductScreen.routeName,
                              arguments: {
                                'product': product,
                                'fromAboutProduct': true,
                              });
                        },
                        text: AppLocalizations.of(context)!.editItem,
                        iconColor: blueColor,
                        textColor: blueColor,
                        iconPath: 'assets/icons/bx_edit.svg',
                        fontSize: 15,
                      ),
                    ),
                    const Gap(5),
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          debugPrint(product!.price!.toString());
                          navigateToCustomerDetailsForm(
                              context,
                              product!,
                              getTotalPrice(
                                  weight: product!.weight!,
                                  rate: goldRates[product!.productType!]!,
                                  jyalaPercent: product!.jyala!,
                                  jartiPercent: product!.jarti,
                                  stonePrice: product!.stone_price!));
                        },
                        text: AppLocalizations.of(context)!.sellItem,
                        iconColor: blueColor,
                        textColor: blueColor,
                        fontSize: 15,
                        iconPath: 'assets/icons/material-symbols_sell.svg',
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
