import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/features/orders/models/old_jwellery_model.dart';
import 'package:grit_qr_scanner/features/orders/screens/customer_details_screen.dart';
import 'package:grit_qr_scanner/provider/order_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../utils/global_variables.dart';
import '../../../utils/utils.dart';
import '../../../utils/widgets/custom_button.dart';

class OldJwelleryScreen extends StatefulWidget {
  static const String routeName = '/old-jwellery-screen';
  const OldJwelleryScreen({super.key});

  @override
  State<OldJwelleryScreen> createState() => _OldJwelleryScreenState();
}

class _OldJwelleryScreenState extends State<OldJwelleryScreen> {
  final _oldJwelleryFormKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _stoneController = TextEditingController();
  final TextEditingController _stonePriceController = TextEditingController();
  final _itemNamefocus = FocusNode();
  final _weightFocus = FocusNode();
  final _stoneFocus = FocusNode();
  final _stonePriceFocus = FocusNode();
  bool _showTotalPrice = false;
  Map<String, double> goldRates = {};
  late List<String> weight;
  late String selectedWeightType;
  late List<String> types;
  late String selectedType;
  bool _dependenciesInitialized = false;
  double currentJwelleryPrice = 0.0;
  double totalPriceToShow = 0.0;

  void calculateTotalPrice() {
    String countryLanguageUsed = Localizations.localeOf(context).countryCode!;
    String? rselectedWeightType;
    String? rselectedType;
    if (countryLanguageUsed == "NP") {
      rselectedWeightType = selectedWeightType == "ग्राम"
          ? "Gram"
          : selectedWeightType == "तोला"
              ? "Tola"
              : "Laal";

      rselectedType = selectedType == "चापावाला"
          ? "Chapawala"
          : selectedType == "तेजाबी"
              ? "Tejabi"
              : "Asal_Chaadhi";
    }

    debugPrint(rselectedType);

    double weight = getWeight(
      double.tryParse(_weightController.text.trim())!,
      rselectedWeightType ?? selectedWeightType,
    );
    double stonePrice = double.tryParse(_stonePriceController.text.trim())!;
    double totalPrice = getTotalPrice(
      weight: weight,
      rate: goldRates[rselectedType ?? selectedType]!,
      jyalaPercent: null,
      jartiPercent: null,
      stonePrice: stonePrice,
    );

    setState(() {
      currentJwelleryPrice = totalPrice;
    });
  }

  void addOtherItem(OrderProvider orderProvider, bool isProceed) {
    String countryLanguageUsed = Localizations.localeOf(context).countryCode!;
    String? rselectedWeightType;
    String? rselectedType;
    if (countryLanguageUsed == "NP") {
      rselectedWeightType = selectedWeightType == "ग्राम"
          ? "Gram"
          : selectedWeightType == "तोला"
              ? "Tola"
              : "Laal";

      rselectedType = selectedType == "चापावाला"
          ? "Chapawala"
          : selectedType == "तेजाबी"
              ? "Tejabi"
              : "Asal_Chaadhi";
    }

    double weight = getWeight(
      double.tryParse(_weightController.text.trim())!,
      rselectedWeightType ?? selectedWeightType,
    );
    double stonePrice = double.tryParse(_stonePriceController.text.trim())!;
    double totalPrice = getTotalPrice(
      weight: weight,
      rate: goldRates[rselectedType ?? selectedType]!,
      jyalaPercent: null,
      jartiPercent: null,
      stonePrice: stonePrice,
    );

    OldJwellery oldJwellery = OldJwellery(
      itemName: _itemNameController.text.trim(),
      wt: weight,
      type: rselectedType ?? selectedType,
      stone: _stoneController.text.trim(),
      stonePrice: stonePrice,
      price: totalPrice,
    );

    orderProvider.addOldJewelry(oldJwellery);
    showSnackBar(
        title: "Old Jwellery Added",
        message: "your old jwellery is added to list",
        contentType: ContentType.success);

    if (isProceed) {
      Navigator.pushNamed(context, CustomerDetailsScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, OldJwelleryScreen.routeName);
    }

    debugPrint(orderProvider.oldJewelries.toString());
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future<void> getGoldRates() async {
    goldRates = await getRate();
  }

  @override
  void didChangeDependencies() {
    if (!_dependenciesInitialized) {
      weight = [
        AppLocalizations.of(context)!.tola,
        AppLocalizations.of(context)!.gram,
        AppLocalizations.of(context)!.laal,
      ];

      types = [
        AppLocalizations.of(context)!.chapawala,
        AppLocalizations.of(context)!.tejabi,
        AppLocalizations.of(context)!.asalChaadhi
      ];

      selectedType = AppLocalizations.of(context)!.chapawala;

      selectedWeightType = AppLocalizations.of(context)!.gram;
      _dependenciesInitialized = true;
      debugPrint("dependency chagned bro");
    }
    debugPrint("dependency chagned sisi");
    super.didChangeDependencies();
  }

  @override
  void initState() {
    getGoldRates();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _itemNameController.dispose();
    _weightController.dispose();
    _stoneController.dispose();
    _stonePriceController.dispose();
    _itemNamefocus.dispose();
    _weightFocus.dispose();
    _stoneFocus.dispose();
    _stonePriceFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        orderProvider.resetOldJwelries();
        if (orderProvider.orderedItems.isNotEmpty) {
          orderProvider.orderedItems
              .removeAt(orderProvider.orderedItems.length - 1);
        }
        showSnackBar(
            title: "Old Jwellery Reset",
            message: "your old jwellery list is empty now!",
            contentType: ContentType.warning);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.oldJewelryItem,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              children: [
                const Gap(10),
                Text(
                  AppLocalizations.of(context)!.fillFormToShowOldJewelry,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: blueColor),
                ),
                const Gap(10),
                Form(
                  key: _oldJwelleryFormKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.itemName,
                        style: customTextDecoration()
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Gap(5),
                      TextFormField(
                        controller: _itemNameController,
                        focusNode: _itemNamefocus,
                        onFieldSubmitted: (value) => _fieldFocusChange(
                            context, _itemNamefocus, _weightFocus),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        cursorColor: blueColor,
                        decoration: customTextfieldDecoration(),
                        validator: (value) {
                          if (value!.isEmpty) return "name cannot be empty";
                          return null;
                        },
                      ),
                      const Gap(10),
                      Text(
                        AppLocalizations.of(context)!.type,
                        style: customTextDecoration()
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Gap(5),
                      DropdownButtonFormField<String>(
                        value: selectedType,
                        iconEnabledColor: const Color(0xFFC3C3C3),
                        iconDisabledColor: const Color(0xFFC3C3C3),
                        iconSize: 25,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                        items: types.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedType = value!;
                            calculateTotalPrice();
                          });
                        },
                        decoration: customTextfieldDecoration(),
                      ),
                      const Gap(10),
                      Text(
                        AppLocalizations.of(context)!.weight,
                        style: customTextDecoration()
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Gap(5),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _weightController,
                              focusNode: _weightFocus,
                              onFieldSubmitted: (value) => _fieldFocusChange(
                                  context, _weightFocus, _stoneFocus),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              textInputAction: TextInputAction.next,
                              decoration: customTextfieldDecoration(),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "weight cannot be empty!";
                                }

                                if (double.tryParse(value) == null) {
                                  return "enter a valid number";
                                }

                                if (double.tryParse(value)! <= 0) {
                                  return "weight cannot be negative/zero";
                                }

                                return null;
                              },
                              onChanged: (value) => calculateTotalPrice(),
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              value: selectedWeightType,
                              iconEnabledColor: const Color(0xFFC3C3C3),
                              iconDisabledColor: const Color(0xFFC3C3C3),
                              iconSize: 25,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                              items: weight.map((category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedWeightType = value!;
                                  calculateTotalPrice();
                                });
                              },
                              decoration: customTextfieldDecoration(),
                            ),
                          ),
                        ],
                      ),
                      const Gap(10),
                      Text(
                        AppLocalizations.of(context)!.stone,
                        style: customTextDecoration()
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Gap(5),
                      TextFormField(
                        controller: _stoneController,
                        focusNode: _stoneFocus,
                        onFieldSubmitted: (value) => _fieldFocusChange(
                            context, _stoneFocus, _stonePriceFocus),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        cursorColor: blueColor,
                        decoration: customTextfieldDecoration(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "stone cannot be empty!";
                          }
                          return null;
                        },
                        onChanged: (value) => calculateTotalPrice(),
                      ),
                      const Gap(10),
                      Text(
                        AppLocalizations.of(context)!.stonePrice,
                        style: customTextDecoration()
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Gap(5),
                      TextFormField(
                        controller: _stonePriceController,
                        focusNode: _stonePriceFocus,
                        onFieldSubmitted: (value) => _stonePriceFocus.unfocus(),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        textInputAction: TextInputAction.done,
                        cursorColor: blueColor,
                        decoration: customTextfieldDecoration(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "stone price cannot be empty!";
                          }
                          if (double.tryParse(value) == null) {
                            return "enter a valid number";
                          }
                          if (double.tryParse(value)! <= 0) {
                            return "stone price cannot be negative/zero";
                          }
                          return null;
                        },
                        onChanged: (value) => calculateTotalPrice(),
                      ),
                    ],
                  ),
                ),
                const Gap(10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.currentPrice}: ",
                        style: const TextStyle(
                            color: greyColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Text(
                        "रु${NumberFormat('#,##,###.00').format(currentJwelleryPrice)}",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const Gap(10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _showTotalPrice
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${AppLocalizations.of(context)!.totalPrice}: रु$totalPriceToShow',
                              key: const ValueKey(true),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20),
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .noteTotalPriceExcludingCurrentOrderPrice,
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic,
                                  color: greyColor),
                            )
                          ],
                        )
                      : ElevatedButton(
                          key: const ValueKey(false),
                          onPressed: () {
                            for (int i = 0;
                                i < orderProvider.oldJewelries.length;
                                i++) {
                              totalPriceToShow +=
                                  orderProvider.oldJewelries[i].price;
                            }
                            setState(() {
                              _showTotalPrice = !_showTotalPrice;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blueColor,
                          ),
                          child: Text(
                            '${AppLocalizations.of(context)!.totalPrice}?',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                ),
                const Gap(15),
                CustomButton(
                  onPressed: () {
                    if (_oldJwelleryFormKey.currentState!.validate()) {
                      addOtherItem(orderProvider, false);
                    }
                  },
                  text: AppLocalizations.of(context)!.addOtherItem,
                  textColor: Colors.white,
                  backgroundColor: blueColor,
                ),
                const Gap(10),
                CustomButton(
                  onPressed: () {
                    if (_oldJwelleryFormKey.currentState!.validate()) {
                      addOtherItem(orderProvider, true);
                    }
                  },
                  text: AppLocalizations.of(context)!.proceed,
                  textColor: Colors.white,
                  backgroundColor: blueColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
