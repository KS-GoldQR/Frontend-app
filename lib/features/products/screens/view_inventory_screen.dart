import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:grit_qr_scanner/features/products/screens/about_product_screen.dart';
import 'package:grit_qr_scanner/features/products/services/product_service.dart';
import 'package:grit_qr_scanner/models/product_model.dart';
import 'package:grit_qr_scanner/provider/product_provider.dart';
import 'package:grit_qr_scanner/utils/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../utils/utils.dart';

class ViewInventoryScreen extends StatefulWidget {
  static const String routeName = '/view-inventory-screen';
  const ViewInventoryScreen({super.key});

  @override
  State<ViewInventoryScreen> createState() => _ViewInventoryScreenState();
}

class _ViewInventoryScreenState extends State<ViewInventoryScreen> {
  List<Product>? products;
  final ProductService _productService = ProductService();
  late List<String> types;
  late String selectedType;
  Map<String, List<Product>> groupedProducts = {};
  Map<String, double> goldRates = {};
  bool _didDependenciesChanged = false;

  Future<void> getInventory() async {
    products = await _productService.getInventory(context);
    setState(() {
      getGroupedProduct();
    });
  }

  void getGroupedProduct() {
    groupedProducts.clear();
    for (var product in products!) {
      dynamic translatedType = product.productType == "Chapawala"
          ? AppLocalizations.of(context)!.chapawala
          : product.productType == "Tejabi"
              ? AppLocalizations.of(context)!.tejabi
              : AppLocalizations.of(context)!.asalChaadhi;

      if (!groupedProducts.containsKey(translatedType)) {
        groupedProducts[translatedType!] = [];
      }
      groupedProducts[translatedType]!.add(product);
    }
  }

  List<Product> getFilteredProducts() {
    return selectedType != AppLocalizations.of(context)!.all
        ? groupedProducts[selectedType] ?? []
        : products ?? [];
  }

  Future<void> getGoldRates() async {
    goldRates = await getRate();
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    if (!_didDependenciesChanged) {
      types = [
        AppLocalizations.of(context)!.all,
        AppLocalizations.of(context)!.chapawala,
        AppLocalizations.of(context)!.tejabi,
        AppLocalizations.of(context)!.asalChaadhi
      ];
      selectedType = AppLocalizations.of(context)!.all;
      _didDependenciesChanged = true;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    getInventory();
    getGoldRates();
    super.initState();
  }

  Future<void> navigateToAboutProduct(Product product) async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productProvider.setProduct(product);

    //cannot show edit/sell option in about page, because from reponse in inventory, product didn't contain validSession argument
    await Navigator.of(context).pushNamed(AboutProduct.routeName,
        arguments: {'product': product, 'fromInventory': true});

    // Trigger refresh when returning from AboutProduct screen
    await getInventory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          AppLocalizations.of(context)!.productInventory,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Center(
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.selectCategory,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF282828),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButtonFormField<String>(
                        decoration: customTextfieldDecoration(),
                        isExpanded: true,
                        isDense: true,
                        value: selectedType,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        iconDisabledColor: const Color(0xFFC3C3C3),
                        iconEnabledColor: const Color(0xFFC3C3C3),
                        elevation: 16,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedType = newValue!;
                            debugPrint(selectedType);
                          });
                        },
                        items:
                            types.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              products == null
                  ? const Center(child: Loader())
                  : products!.isEmpty
                      ? Center(
                          child: Text(
                              "${AppLocalizations.of(context)!.noProductsFoundInInventory}!"),
                        )
                      : getFilteredProducts().isEmpty
                          ? Center(
                              child: Text(AppLocalizations.of(context)!
                                  .noProductsFound),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var entry in groupedProducts.entries)
                                  if (selectedType ==
                                          AppLocalizations.of(context)!.all ||
                                      entry.key == selectedType)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          entry.key,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        ...entry.value.map((product) {
                                          debugPrint(product.image);
                                          return ListTile(
                                            onTap: () async {
                                              await navigateToAboutProduct(
                                                  product);
                                            },
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            title: Text(
                                              product.name!,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            subtitle: goldRates.isEmpty
                                                ? const Text(
                                                    "fetching rates...")
                                                : Text(
                                                    "रु${getTotalPrice(weight: product.weight!, rate: goldRates[product.productType!]!, jyalaPercent: product.jyala!, jartiPercent: product.jarti!, stonePrice: product.stone_price!)}"),
                                            trailing: Text(product.stone!),
                                            leading: CachedNetworkImage(
                                              height: 250,
                                              width: 50,
                                              imageUrl: product.image!,
                                              fit: BoxFit.cover,
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  const Icon(
                                                      Remix.error_warning_fill),
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                              ],
                            ),
            ],
          ),
        ),
      ),
    );
  }
}
