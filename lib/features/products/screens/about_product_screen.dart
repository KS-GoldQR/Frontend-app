import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/features/products/screens/edit_product_screen.dart';
import 'package:grit_qr_scanner/features/sales/screens/sales_details_screen.dart';
import 'package:grit_qr_scanner/models/sales_model.dart';
import 'package:grit_qr_scanner/provider/product_provider.dart';
import 'package:grit_qr_scanner/provider/sales_provider.dart';
import 'package:grit_qr_scanner/provider/user_provider.dart';
import 'package:grit_qr_scanner/utils/form_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:remixicon/remixicon.dart';

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
  final TextEditingController _jyalaController = TextEditingController();
  final TextEditingController _jartiController = TextEditingController();
  final TextEditingController _totalPriceController = TextEditingController();
  final _jyalaFocus = FocusNode();
  final _jartiFocus = FocusNode();

  final String productDescription = "Description not added yet!";

  // void navigateToCustomerDetailsForm(
  //     BuildContext context, Product product, double jyala, double jarti, double totalPrice) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => CustomerDetailsForm(
  //         product: product,
  //         jyala: jyala,
  //         jarti: jarti,
  //         totalPrice: totalPrice,
  //       ),
  //     ),
  //   );
  // }

  void navigateToSalesDetailsScreen(
      SalesProvider salesProvider,
      Product product,
      double jyala,
      double jarti,
      double totalPrice,
      double weight) {
    for (int i = 0; i < salesProvider.saleItems.length; i++) {
      if (salesProvider.saleItems[i].product.id == product.id) {
        showSnackBar(
            title: AppLocalizations.of(context)!.duplicateFound,
            message: AppLocalizations.of(context)!.itemAlreadyInList,
            contentType: ContentType.warning);
        return;
      }
    }

    SalesModel item = SalesModel(
        product: product,
        price: totalPrice,
        weight: weight,
        jyalaPercentage: jyala,
        jartiPercentage: jarti);

    salesProvider.addSaleItem(item);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SalesDetailsScreen(),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () async {
      await getRate(context);
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _jyalaController.dispose();
    _jartiController.dispose();
    _totalPriceController.dispose();
    _jyalaFocus.dispose();
    _jartiFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final salesProvider = Provider.of<SalesProvider>(context, listen: false);

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
      body: goldRates.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                        textAlign: TextAlign
                            .justify, // Your full product description here
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
                            errorWidget: (context, url, error) => Text(
                                AppLocalizations.of(context)!
                                    .errorGettingImage),
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
                        label: '${AppLocalizations.of(context)!.actualPrice}: ',
                        value:
                            "रु${NumberFormat('#,##,###.00').format(product!.weight! * goldRates[product!.productType!]!)}"),
                    if (product!.stone != "None")
                      ProductDetail(
                          label: '${AppLocalizations.of(context)!.stone}: ',
                          value: product!.stone!),
                    if (product!.stone_price != null)
                      ProductDetail(
                          label:
                              '${AppLocalizations.of(context)!.stonePrice}: ',
                          value:
                              "रु${NumberFormat('#,##,###.00').format(product!.stone_price)}"),
                    Row(
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.jyala} (%): ',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Gap(8),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.5,
                          child: TextFormField(
                            controller: _jyalaController
                              ..text = product!.jyala.toString(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onTapOutside: (event) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                            cursorColor: Colors.black,
                            cursorOpacityAnimates: false,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            style: const TextStyle(fontSize: 16),
                            focusNode: _jyalaFocus,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              isCollapsed: true,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: _jyalaFocus.hasFocus
                                        ? Colors.black
                                        : Colors.white),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            onChanged: (value) {
                              _jyalaController.text = value;
                              _totalPriceController.text =
                                  "रु${NumberFormat('#,##,###.00').format(getTotalPrice(weight: product!.weight!, rate: goldRates[product!.productType!]!, jyalaPercent: double.tryParse(_jyalaController.text) ?? product!.jyala!, jartiPercent: double.tryParse(_jartiController.text) ?? product!.jarti!, stonePrice: product!.stone_price ?? 0.0))}";
                            },
                            validator: (value) =>
                                validateJyala(value!, context),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            _jyalaFocus.requestFocus();
                          },
                          child: const Icon(
                            Remix.edit_2_line,
                            size: 20,
                          ),
                        ),
                        const Gap(20),
                      ],
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.jarti} (%): ',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Gap(8),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.5,
                          child: TextFormField(
                            controller: _jartiController
                              ..text = product!.jarti.toString(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onTapOutside: (event) =>
                                FocusManager.instance.primaryFocus?.unfocus(),
                            cursorColor: Colors.black,
                            cursorOpacityAnimates: false,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            style: const TextStyle(fontSize: 16),
                            focusNode: _jartiFocus,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              isCollapsed: true,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: _jartiFocus.hasFocus
                                        ? Colors.black
                                        : Colors.white),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            onChanged: (value) {
                              _jartiController.text = value;
                              _totalPriceController.text =
                                  "रु${NumberFormat('#,##,###.00').format(getTotalPrice(weight: product!.weight!, rate: goldRates[product!.productType!]!, jyalaPercent: double.tryParse(_jyalaController.text) ?? product!.jyala!, jartiPercent: double.tryParse(_jartiController.text) ?? product!.jarti!, stonePrice: product!.stone_price ?? 0.0))}";
                              debugPrint(
                                  "inside jayala ${_jartiController.text}");
                            },
                            validator: (value) =>
                                validateJarti(value!, context),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            _jartiFocus.requestFocus();
                          },
                          child: const Icon(
                            Remix.edit_2_line,
                            size: 20,
                          ),
                        ),
                        const Gap(20),
                      ],
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.price}: ',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Gap(8),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.5,
                          child: TextFormField(
                            controller: _totalPriceController
                              ..text =
                                  "रु${NumberFormat('#,##,###.00').format(getTotalPrice(weight: product!.weight!, rate: goldRates[product!.productType!]!, jyalaPercent: product!.jyala!, jartiPercent: product!.jarti!, stonePrice: product!.stone_price ?? 0.0))}",
                            enabled: false, // Disable user input
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              isCollapsed: true,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            onChanged: (value) {
                              _totalPriceController.text =
                                  "रु${NumberFormat('#,##,###.00').format(getTotalPrice(weight: product!.weight!, rate: goldRates[product!.productType!]!, jyalaPercent: double.tryParse(_jyalaController.text) ?? product!.jyala!, jartiPercent: double.tryParse(_jartiController.text) ?? product!.jarti!, stonePrice: product!.stone_price ?? 0.0))}";
                            },
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    if (product!.updatedAt != null)
                      ProductDetail(
                          label:
                              "${AppLocalizations.of(context)!.lastUpdate}: ",
                          value: formatDateTimeRange(product!.updatedAt!)),
                    const Gap(20),
                    if (product!.validSession == "1" ||
                        widget.args['fromInventory'])
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
                                      'fromRouteName': AboutProduct.routeName,
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
                                // navigateToCustomerDetailsForm(
                                //     context,
                                //     product!,
                                //     double.tryParse(_jyalaController.text) ??
                                //         product!.jyala!,
                                //     double.tryParse(_jartiController.text) ??
                                //         product!.jarti!,
                                //     double.tryParse(_totalPriceController.text) ??
                                //         getTotalPrice(
                                //             weight: product!.weight!,
                                //             rate: goldRates[product!.productType!]!,
                                //             jyalaPercent: double.tryParse(
                                //                     _jyalaController.text) ??
                                //                 product!.jyala!,
                                //             jartiPercent: double.tryParse(
                                //                     _jartiController.text) ??
                                //                 product!.jarti,
                                //             stonePrice: product!.stone_price ?? 0.0));

                                navigateToSalesDetailsScreen(
                                    salesProvider,
                                    product!,
                                    double.tryParse(_jyalaController.text) ??
                                        product!.jyala!,
                                    double.tryParse(_jartiController.text) ??
                                        product!.jarti!,
                                    double.tryParse(
                                            _totalPriceController.text) ??
                                        getTotalPrice(
                                            weight: product!.weight!,
                                            rate: goldRates[
                                                product!.productType!]!,
                                            jyalaPercent: double.tryParse(
                                                    _jyalaController.text) ??
                                                product!.jyala!,
                                            jartiPercent: double.tryParse(
                                                    _jartiController.text) ??
                                                product!.jarti,
                                            stonePrice:
                                                product!.stone_price ?? 0.0),
                                    product!.weight!);
                              },
                              text: AppLocalizations.of(context)!.sellItem,
                              iconColor: blueColor,
                              textColor: blueColor,
                              fontSize: 15,
                              iconPath:
                                  'assets/icons/material-symbols_sell.svg',
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
