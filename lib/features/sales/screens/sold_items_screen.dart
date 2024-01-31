import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/features/sales/service/sales_service.dart';
import 'package:grit_qr_scanner/features/sales/widgets/sold_item_details.dart';
import 'package:remixicon/remixicon.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../models/product_model.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/utils.dart';
import '../../../utils/widgets/loader.dart';

class SoldItemsScreen extends StatefulWidget {
  static const String routeName = '/sold-items-screen';
  const SoldItemsScreen({super.key});

  @override
  State<SoldItemsScreen> createState() => _ViewSoldItemsState();
}

class _ViewSoldItemsState extends State<SoldItemsScreen> {
  final _uniqueKey = GlobalKey();
  List<Product>? products;
  final SalesService _salesService = SalesService();
  late List<String> types;
  late String selectedType;
  Map<String, List<Product>> groupedProducts = {};
  DateTime? startDate;
  DateTime? endDate;

  Future<void> getSoldItems() async {
    products = await _salesService.viewSoldItems(context);
    setState(() {
      getGroupedProduct();
    });
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
    return (selectedType != AppLocalizations.of(context)!.all
            ? groupedProducts[selectedType] ?? []
            : products ?? [])
        .where((product) {
      if (startDate == null && endDate == null) {
        return true;
      }
      if (startDate != null && endDate == null) {
        return product.soldAt != null && product.soldAt!.isAfter(startDate!);
      }
      if (startDate == null && endDate != null) {
        return product.soldAt != null && product.soldAt!.isBefore(endDate!);
      }
      if (startDate != null && endDate != null) {
        return product.soldAt != null &&
            product.soldAt!.isAfter(startDate!) &&
            product.soldAt!.isBefore(endDate!.add(const Duration(days: 1)));
      }
      return false; // Handle any other cases if necessary
    }).toList();
  }

  Future<void> showFullScreenDialog(
      BuildContext context, Product product) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SoldItemDetails(product: product)));
      },
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate:
          isStartDate ? startDate ?? DateTime.now() : endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = selectedDate;
        } else {
          endDate = selectedDate;
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    types = [
      AppLocalizations.of(context)!.all,
      AppLocalizations.of(context)!.chhapawal,
      AppLocalizations.of(context)!.tejabi,
      AppLocalizations.of(context)!.asalChandi
    ];
    selectedType = AppLocalizations.of(context)!.all;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, getSoldItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.soldItems),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(15),
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
              dateRangePicker(context),
              const Gap(15),
              products == null
                  ? const Center(child: Loader())
                  : products!.isEmpty
                      ? Center(
                          child: Text(AppLocalizations.of(context)!
                              .noProductHasBeenSold),
                        )
                      : getFilteredProducts().isEmpty
                          ? Center(
                              child: Text(AppLocalizations.of(context)!
                                  .noProductHasBeenSold),
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
                                          return ListTile(
                                            onTap: () {
                                              showFullScreenDialog(
                                                  context, product);
                                            },
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            title: Text(
                                              product.name!,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            subtitle:
                                                Text("रु${product.price}"),
                                            trailing: Text(product.stone!),
                                            leading: CachedNetworkImage(
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

  Row dateRangePicker(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () => _selectDate(context, true),
          icon: const Icon(
            Icons.calendar_month_outlined,
            color: blueColor,
          ),
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft),
          label: Text(
            startDate != null ? formatDateTimeRange(startDate!) : 'from',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
        Visibility(
          visible: startDate != null && endDate != null,
          child: const Text("-"),
        ),
        TextButton.icon(
          onPressed: () => _selectDate(context, false),
          icon: const Icon(
            Icons.calendar_month_outlined,
            color: blueColor,
          ),
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerLeft),
          label: Text(
            endDate != null ? formatDateTimeRange(endDate!) : 'to',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
        ),
        TextButton(
            onPressed: () {
              setState(() {
                startDate = null;
                endDate = null;
              });
            },
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(50, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                alignment: Alignment.centerLeft),
            child: Text(
              AppLocalizations.of(context)!.clear,
              style: const TextStyle(
                  color: blueColor, fontWeight: FontWeight.bold),
            ))
      ],
    );
  }
}
