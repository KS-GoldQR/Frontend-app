import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

import '../../../models/product_model.dart';
import '../../../provider/product_provider.dart';
import '../../../utils/custom_decorators.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/utils.dart';
import '../../../utils/widgets/loader.dart';
import '../../../services/product_service.dart';
import 'about_product_screen.dart';

class ViewInventoryScreen extends StatefulWidget {
  static const String routeName = '/view-inventory-screen';
  const ViewInventoryScreen({super.key});

  @override
  State<ViewInventoryScreen> createState() => _ViewInventoryScreenState();
}

class _ViewInventoryScreenState extends State<ViewInventoryScreen> {
  List<Product>? products;
  final ProductService _productService = ProductService();
  final GlobalKey _uniqueKey = GlobalKey();
  final GlobalKey _circularProgressIndicatorKey = GlobalKey();
  late List<String> types;
  late String selectedProductType;
  Map<String, List<Product>> groupedProducts = {};
  bool _didDependenciesChanged = false;

  Future<void> getInventory() async {
    if (mounted) {
      products = await _productService.getInventory(context);
      if (mounted) {
        setState(() {
          getGroupedProduct();
        });
      }
    }
  }

  void getGroupedProduct() {
    groupedProducts.clear();
    for (var product in products!) {
      dynamic translatedType = product.productType == "Chhapawal"
          ? AppLocalizations.of(context)!.chhapawal
          : product.productType == "Tejabi"
              ? AppLocalizations.of(context)!.tejabi
              : AppLocalizations.of(context)!.asalChandi;

      if (!groupedProducts.containsKey(translatedType)) {
        groupedProducts[translatedType!] = [];
      }
      groupedProducts[translatedType]!.add(product);
    }
  }

  List<Product> getFilteredProducts() {
    return selectedProductType != AppLocalizations.of(context)!.all
        ? groupedProducts[selectedProductType] ?? []
        : products ?? [];
  }

  @override
  void didChangeDependencies() {
    if (!_didDependenciesChanged) {
      types = [
        AppLocalizations.of(context)!.all,
        AppLocalizations.of(context)!.chhapawal,
        AppLocalizations.of(context)!.tejabi,
        AppLocalizations.of(context)!.asalChandi
      ];
      selectedProductType = AppLocalizations.of(context)!.all;
      _didDependenciesChanged = true;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await getRate(context);
      if (mounted) {
        getInventory();
      }
    });
  }

  Future<void> navigateToAboutProduct(Product product) async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    productProvider.setProduct(product);

    //cannot show edit/sell option in about page, because from reponse in inventory, product didn't contain validSession argument
    // await Navigator.of(context)
    //     .pushNamed(AboutProduct.routeName, arguments: {'fromInventory': true});

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AboutProduct(
          args: {'fromInventory': true},
        ),
      ),
    );

    // Trigger refresh when returning from AboutProduct screen
    if (mounted) {
      getInventory();
    }
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
                        key: _uniqueKey,
                        decoration: customTextfieldDecoration(),
                        isExpanded: true,
                        isDense: true,
                        value: selectedProductType,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        iconDisabledColor: const Color(0xFFC3C3C3),
                        iconEnabledColor: const Color(0xFFC3C3C3),
                        elevation: 16,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedProductType = newValue!;
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
                  ? Center(
                      child: Loader(
                      circularIndicatiorKey: _circularProgressIndicatorKey,
                    ))
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
                                  if (selectedProductType ==
                                          AppLocalizations.of(context)!.all ||
                                      entry.key == selectedProductType)
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
                                            // subtitle: goldRates.isEmpty
                                            //     ? const Text(
                                            //         "error fetching rates...")
                                            //     : Text(
                                            //         "रु ${getTotalPrice(weight: product.weight!, rate: goldRates[product.productType!]!, jyala: product.jyala!, jarti: product.jarti!, stonePrice: product.stone_price ?? 0.0)}"),
                                            subtitle: product.updatedAt != null
                                                ? Text(
                                                    "${AppLocalizations.of(context)!.lastUpdate}: ${formatDateTime(product.updatedAt!)}")
                                                : goldRates.isEmpty
                                                    ? const Text(
                                                        "error fetching rates...")
                                                    : Text(
                                                        "रु ${getTotalPrice(weight: product.weight!, rate: goldRates[product.productType!]!, jyala: product.jyala!, jarti: product.jarti!, stonePrice: product.stone_price ?? 0.0)}"),
                                            // trailing: Text(
                                            //     "रु ${getNumberFormat(product.price!)}"),
                                            leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: CachedNetworkImage(
                                                height: 250,
                                                width: 80,
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
                                                    const Icon(Remix
                                                        .error_warning_fill),
                                              ),
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
