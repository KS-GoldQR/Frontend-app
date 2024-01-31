import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/features/orders/models/ordered_items_model.dart';
import 'package:grit_qr_scanner/features/orders/screens/customer_details_screen.dart';
import 'package:grit_qr_scanner/features/orders/screens/old_jwellery_screen.dart';
import 'package:grit_qr_scanner/provider/order_provider.dart';
import 'package:grit_qr_scanner/utils/form_validators.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:grit_qr_scanner/utils/widgets/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../utils/utils.dart';

class CreateOrderScreen extends StatefulWidget {
  static const String routeName = '/create-order-screen';
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _createOrderFormKey = GlobalKey<FormState>();

  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _jyalaController = TextEditingController();
  final TextEditingController _jartiController = TextEditingController();
  final TextEditingController _stoneController = TextEditingController();
  final TextEditingController _stonePriceController = TextEditingController();
  final _itemNamefocus = FocusNode();
  final _weightFocus = FocusNode();
  final _jyalaFocus = FocusNode();
  final _jartiFocus = FocusNode();
  final _stoneFocus = FocusNode();
  final _stonePriceFocus = FocusNode();
  bool _showTotalPrice = false;
  late List<String> weight;
  late String selectedWeightType;
  late List<String> types;
  late String selectedType;
  double currentOrderPrice = 0.0;
  double totalPriceToShow = 0.0;
  bool _dependenciesInitialized = false;
  bool _stonePriceFieldVisible = false;

  void _showChoiceDialog(OrderProvider orderProvider) {
    Future.delayed(Duration.zero, () {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.question,
        animType: AnimType.rightSlide,
        title: 'Old Jwellery',
        desc: 'Any old jewelry deposited?',
        btnOkText: 'Yes',
        btnCancelText: 'No',
        btnOkColor: blueColor,
        btnCancelColor: blueColor,
        btnCancelOnPress: () {
          addOtherItem(orderProvider, true);
          Navigator.pushNamed(context, CustomerDetailsScreen.routeName);
        },
        btnOkOnPress: () {
          addOtherItem(orderProvider, true);
          Navigator.pushNamed(context, OldJwelleryScreen.routeName);
        },
      ).show();
    });
  }

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

      rselectedType = selectedType == "छापावाल"
          ? "Chhapawal"
          : selectedType == "तेजाबी"
              ? "Tejabi"
              : "Asal Chandi";
    }

    debugPrint(rselectedType);
    debugPrint(goldRates.toString());

    double weight = getWeight(
      double.tryParse(_weightController.text.trim())!,
      rselectedWeightType ?? selectedWeightType,
    );
    double jyala = double.tryParse(_jyalaController.text.trim())!;
    double jarti = double.tryParse(_jartiController.text.trim())!;
    double stonePrice = _stonePriceController.text.isEmpty
        ? 0.0
        : double.tryParse(_stonePriceController.text.trim())!;
    double totalPrice = getTotalPrice(
      weight: weight,
      rate: goldRates[rselectedType ?? selectedType]!,
      jyalaPercent: jyala,
      jartiPercent: jarti,
      stonePrice: stonePrice,
    );

    setState(() {
      currentOrderPrice = totalPrice;
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

      rselectedType = selectedType == "छापावाल"
          ? "Chhapawal"
          : selectedType == "तेजाबी"
              ? "Tejabi"
              : "Asal Chandi";
    }

    debugPrint(rselectedType);

    double weight = getWeight(
      double.tryParse(_weightController.text.trim())!,
      rselectedWeightType ?? selectedWeightType,
    );
    double jyala = double.tryParse(_jyalaController.text.trim())!;
    double jarti = double.tryParse(_jartiController.text.trim())!;
    double stonePrice = _stonePriceController.text.isEmpty
        ? 0.0
        : double.tryParse(_stonePriceController.text.trim())!;
    double totalPrice = getTotalPrice(
      weight: weight,
      rate: goldRates[rselectedType ?? selectedType]!,
      jyalaPercent: jyala,
      jartiPercent: jarti,
      stonePrice: stonePrice,
    );

    OrderedItems orderedItem = OrderedItems(
      itemName: _itemNameController.text.trim(),
      wt: weight,
      type: rselectedType ?? selectedType,
      jarti: jarti,
      jyala: jyala,
      stone: _stoneController.text.trim(),
      stonePrice: stonePrice,
      totalPrice: totalPrice,
    );

    orderProvider.addOrderedItems(orderedItem);

    showSnackBar(
        title: "Order Added",
        message: "your order is added to list",
        contentType: ContentType.success);

    if (!isProceed) {
      Navigator.pushReplacementNamed(context, CreateOrderScreen.routeName);
    }

    debugPrint(orderProvider.orderedItems.toString());
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
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
        AppLocalizations.of(context)!.chhapawal,
        AppLocalizations.of(context)!.tejabi,
        AppLocalizations.of(context)!.asalChandi
      ];

      selectedType = AppLocalizations.of(context)!.chhapawal;

      selectedWeightType = AppLocalizations.of(context)!.gram;
      _dependenciesInitialized = true;
      debugPrint("dependency chagned bro");
    }
    debugPrint("dependency chagned sisi");
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await getRate(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _itemNameController.dispose();
    _weightController.dispose();
    _jartiController.dispose();
    _jyalaController.dispose();
    _stoneController.dispose();
    _stonePriceController.dispose();
    _itemNamefocus.dispose();
    _weightFocus.dispose();
    _jartiFocus.dispose();
    _jyalaFocus.dispose();
    _stoneFocus.dispose();
    _stonePriceFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        orderProvider.resetOrders();
        showSnackBar(
            title: "Order Cancelled",
            message: "all orders are cancelled",
            contentType: ContentType.warning);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.createOrder,
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
                  AppLocalizations.of(context)!.fillFormToCreateOrder,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: blueColor),
                ),
                const Gap(10),
                Form(
                  key: _createOrderFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.name,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => validateName(value!, context),
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
                                  context, _weightFocus, _jyalaFocus),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              textInputAction: TextInputAction.next,
                              decoration: customTextfieldDecoration(),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) =>
                                  validateWeight(value!, context),
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
                        "${AppLocalizations.of(context)!.jyala} (%) ",
                        style: customTextDecoration()
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Gap(5),
                      TextFormField(
                        controller: _jyalaController,
                        focusNode: _jyalaFocus,
                        onFieldSubmitted: (value) => _fieldFocusChange(
                            context, _jyalaFocus, _jartiFocus),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        textInputAction: TextInputAction.next,
                        cursorColor: blueColor,
                        decoration: customTextfieldDecoration(),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => validateJyala(value!, context),
                        onChanged: (value) => calculateTotalPrice(),
                      ),
                      const Gap(10),
                      Text(
                        "${AppLocalizations.of(context)!.jarti} (%) ",
                        style: customTextDecoration()
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Gap(5),
                      TextFormField(
                        controller: _jartiController,
                        focusNode: _jartiFocus,
                        onFieldSubmitted: (value) => _fieldFocusChange(
                            context, _jartiFocus, _stoneFocus),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        textInputAction: TextInputAction.next,
                        cursorColor: blueColor,
                        decoration: customTextfieldDecoration(),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => validateJarti(value!, context),
                        onChanged: (value) => calculateTotalPrice(),
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
                        onChanged: (value) {
                          setState(() {
                            _stonePriceFieldVisible = value.isNotEmpty;
                            if (!_stonePriceFieldVisible) {
                              _stonePriceController.text = "";
                            }
                          });
                        },
                      ),
                      const Gap(10),
                      Visibility(
                        visible: _stonePriceFieldVisible,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.stonePrice,
                              style: customTextDecoration()
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            const Gap(5),
                            TextFormField(
                              controller: _stonePriceController,
                              focusNode: _stonePriceFocus,
                              onFieldSubmitted: (value) =>
                                  _stonePriceFocus.unfocus(),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              textInputAction: TextInputAction.done,
                              cursorColor: blueColor,
                              decoration: customTextfieldDecoration(),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) =>
                                  validateStonePrice(value!, context),
                              onChanged: (value) => calculateTotalPrice(),
                            ),
                          ],
                        ),
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
                        "रु${NumberFormat('#,##,###.00').format(currentOrderPrice)}",
                        style: const TextStyle(
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                                i < orderProvider.orderedItems.length;
                                i++) {
                              totalPriceToShow +=
                                  orderProvider.orderedItems[i].totalPrice;
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
                    if (_createOrderFormKey.currentState!.validate()) {
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
                    if (_createOrderFormKey.currentState!.validate()) {
                      _showChoiceDialog(orderProvider);
                    }
                  },
                  text: AppLocalizations.of(context)!.proceed,
                  textColor: Colors.white,
                  backgroundColor: blueColor,
                ),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
