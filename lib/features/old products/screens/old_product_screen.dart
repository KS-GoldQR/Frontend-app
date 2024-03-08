import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/features/old%20products/models/old_product_model.dart';
import 'package:grit_qr_scanner/features/old%20products/screens/add_old_product_screen.dart';
import 'package:grit_qr_scanner/features/old%20products/screens/view_old_product_screen.dart';
import 'package:grit_qr_scanner/features/old%20products/services/old_product_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:remixicon/remixicon.dart';

import '../../../utils/global_variables.dart';
import '../../../utils/utils.dart';
import '../../../utils/widgets/loader.dart';

class OldProductsScreen extends StatefulWidget {
  static const String routeName = "/old-products-screen";
  const OldProductsScreen({super.key});

  @override
  State<OldProductsScreen> createState() => _OldProductsScreenState();
}

class _OldProductsScreenState extends State<OldProductsScreen> {
  List<OldProductModel>? products;
  final OldProductService _oldProductService = OldProductService();
  final GlobalKey _circularProgressIndicatorKey = GlobalKey();

  late List<String> types;
  late String selectedProductType;
  Map<String, List<OldProductModel>> groupedProducts = {};
  bool _didDependenciesChanged = false;

  Future<void> getOldProducts() async {
    if (mounted) {
      products = await _oldProductService.getOldProducts(context);
      setState(() {
        getGroupedProduct();
      });
    }
  }

  Future<void> deleteOldProduct(String productId) async {
    bool isDeleted = await _oldProductService.deleteOldProduct(
        context: context, productId: productId);
    //update without hitting api
    setState(() {
      if (isDeleted) {
        products?.removeWhere((element) => element.id == productId);
        getGroupedProduct();
      }
    });
  }

  void navigateToAddProductScreen() async {
    await navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => const AddOldProductScreen(),
      ),
    );
    if (mounted) {
      getOldProducts();
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

  List<OldProductModel> getFilteredProducts() {
    return selectedProductType != AppLocalizations.of(context)!.all
        ? groupedProducts[selectedProductType] ?? []
        : products ?? [];
  }

  Future<void> _showChoiceDialog(BuildContext context, String productId) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.rightSlide,
      title: AppLocalizations.of(context)!.areYouSure,
      desc: '',
      btnOkText: AppLocalizations.of(context)!.yes,
      btnCancelText: AppLocalizations.of(context)!.no,
      btnOkColor: Colors.green,
      btnCancelColor: Colors.red,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        deleteOldProduct(productId);
      },
    ).show();
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
        getOldProducts();
      }
    });
  }

  Future<void> navigateToAboutProduct(OldProductModel product) async {
    navigatorKey.currentState!.push(
      MaterialPageRoute(
        builder: (context) => ViewOldProductScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          AppLocalizations.of(context)!.oldProduct,
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
                              AppLocalizations.of(context)!.noProductsFound),
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
                                              product.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            subtitle: goldRates.isEmpty
                                                ? Text(AppLocalizations.of(
                                                        context)!
                                                    .errorFetchingRates)
                                                : Text(
                                                    "रु${NumberFormat('#,##,###.00').format((product.weight * goldRates[product.productType]!) + (product.stonePrice ?? 0.0))}"),
                                            trailing: IconButton(
                                              onPressed: () =>
                                                  _showChoiceDialog(
                                                      context, product.id),
                                              icon: const Icon(
                                                Remix.delete_bin_7_line,
                                                color: blueColor,
                                              ),
                                            ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: blueColor,
        onPressed: navigateToAddProductScreen,
        child: const Icon(
          Remix.add_line,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
