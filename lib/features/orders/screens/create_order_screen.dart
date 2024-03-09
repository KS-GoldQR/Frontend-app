import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../provider/order_provider.dart';
import '../../../utils/custom_decorators.dart';
import '../../../utils/form_validators.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/utils.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../reusable%20components/final_preview_screen.dart';
import '../models/ordered_items_model.dart';
import 'old_jwellery_screen.dart';

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
  // bool _showTotalPrice = false;
  late List<String> weight;
  late String selectedWeightType;
  late List<String> types;
  late List<String> jartiWeightTypeList;
  late String selectedProductType;
  late String selectedJartiWeightType;
  double currentOrderPrice = 0.0;
  double totalPriceToShow = 0.0;
  bool _dependenciesInitialized = false;
  bool _stonePriceFieldVisible = false;

  void _showChoiceDialog(OrderProvider orderProvider, bool allEmptyField) {
    Future.delayed(Duration.zero, () {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.question,
        animType: AnimType.rightSlide,
        title: AppLocalizations.of(context)!.oldJewellery,
        desc: AppLocalizations.of(context)!.anyOldJwelleryDeposited,
        btnOkText: AppLocalizations.of(context)!.yes,
        btnCancelText: AppLocalizations.of(context)!.no,
        btnOkColor: blueColor,
        btnCancelColor: blueColor,
        btnCancelOnPress: () {
          if (!allEmptyField) addOtherItem(orderProvider, true);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FinalPreviewScreen(isSales: false),
            ),
          );
        },
        btnOkOnPress: () {
          if (!allEmptyField) addOtherItem(orderProvider, true);
          Navigator.pushNamed(context, OldJwelleryScreen.routeName,
              arguments: false);
        },
      ).show();
    });
  }

  void calculateTotalPrice() {
    var (rselectedWeightType, rselectedType, rselectedJartiWeightType) =
        translatedTypes(
            context: context,
            selectedWeightType: selectedWeightType,
            selectedProductType: selectedProductType,
            selectedJartiWeightType: selectedJartiWeightType);

    double weight = getWeightInGram(
      double.tryParse(_weightController.text.trim())!,
      rselectedWeightType ?? selectedWeightType,
    );
    double jyala = double.tryParse(_jyalaController.text.trim())!;
    double stonePrice = _stonePriceController.text.isEmpty
        ? 0.0
        : double.tryParse(_stonePriceController.text.trim())!;

    double jarti = getWeightInGram(
        double.tryParse(_jartiController.text.trim())!,
        rselectedJartiWeightType!);
    double totalPrice = getTotalPrice(
      weight: weight,
      rate: goldRates[rselectedType ?? selectedProductType]!,
      jyala: jyala,
      jarti: jarti,
      stonePrice: stonePrice,
    );

    setState(() {
      currentOrderPrice = totalPrice;
    });
  }

  void addOtherItem(OrderProvider orderProvider, bool isProceed) {
    var (rselectedWeightType, rselectedType, rselectedJartiWeightType) =
        translatedTypes(
            context: context,
            selectedWeightType: selectedWeightType,
            selectedProductType: selectedProductType,
            selectedJartiWeightType: selectedJartiWeightType);

    double weight = getWeightInGram(
      double.tryParse(_weightController.text.trim())!,
      rselectedWeightType ?? selectedWeightType,
    );
    double jyala = double.tryParse(_jyalaController.text.trim())!;
    double jarti = getWeightInGram(
        double.tryParse(_jartiController.text.trim())!,
        rselectedJartiWeightType!);
    double? stonePrice = _stonePriceController.text.isEmpty
        ? null
        : double.tryParse(_stonePriceController.text.trim())!;
    double totalPrice = getTotalPrice(
      weight: weight,
      rate: goldRates[rselectedType ?? selectedProductType]!,
      jyala: jyala,
      jarti: jarti,
      stonePrice: stonePrice ?? 0.0,
    );

    OrderedItems orderedItem = OrderedItems(
      itemName: _itemNameController.text.trim(),
      wt: weight,
      type: rselectedType ?? selectedProductType,
      jarti: double.tryParse(_jartiController.text.trim())!,
      jyala: jyala,
      jartiType: rselectedJartiWeightType,
      stone:
          _stoneController.text.isEmpty ? null : _stoneController.text.trim(),
      stonePrice: stonePrice,
      totalPrice: totalPrice,
    );

    debugPrint("order adding.");
    orderProvider.addOrderedItems(orderedItem);
    _createOrderFormKey.currentState!.reset();

    Navigator.popAndPushNamed(
        context, CreateOrderScreen.routeName); //to reset form details

    if (!isProceed) {
      Navigator.pushReplacementNamed(context, CreateOrderScreen.routeName);
    }
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

      jartiWeightTypeList = getJartiWeightType(context);

      selectedProductType = AppLocalizations.of(context)!.chhapawal;

      selectedWeightType = AppLocalizations.of(context)!.gram;
      selectedJartiWeightType = AppLocalizations.of(context)!.laal;
      _dependenciesInitialized = true;
    }

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
    final orderProvider = Provider.of<OrderProvider>(context, listen: true);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
                        value: selectedProductType,
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
                            selectedProductType = value!;
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
                        "${AppLocalizations.of(context)!.jyala} ",
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
                        "${AppLocalizations.of(context)!.jarti}  ",
                        style: customTextDecoration()
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Gap(5),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _jartiController,
                              focusNode: _jartiFocus,
                              onFieldSubmitted: (value) => _fieldFocusChange(
                                  context, _jartiFocus, _stoneFocus),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              textInputAction: TextInputAction.next,
                              cursorColor: blueColor,
                              decoration: customTextfieldDecoration(),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) =>
                                  validateJarti(value!, context),
                              onChanged: (value) => calculateTotalPrice(),
                            ),
                          ),
                          const Gap(10),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              value: selectedJartiWeightType,
                              iconEnabledColor: const Color(0xFFC3C3C3),
                              iconDisabledColor: const Color(0xFFC3C3C3),
                              iconSize: 25,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                              items: jartiWeightTypeList.map((category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedJartiWeightType = value!;
                                });
                                calculateTotalPrice();
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
                // AnimatedSwitcher(
                //   duration: const Duration(milliseconds: 500),
                //   child: _showTotalPrice
                //       ? Column(
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Text(
                //               '${AppLocalizations.of(context)!.totalPrice}: रु${NumberFormat('#,##,###.00').format(totalPriceToShow)}',
                //               key: const ValueKey(true),
                //               textAlign: TextAlign.center,
                //               style: const TextStyle(fontSize: 20),
                //             ),
                //             Text(
                //               AppLocalizations.of(context)!
                //                   .noteTotalPriceExcludingCurrentOrderPrice,
                //               style: const TextStyle(
                //                   fontSize: 10,
                //                   fontStyle: FontStyle.italic,
                //                   color: greyColor),
                //             )
                //           ],
                //         )
                //       : ElevatedButton(
                //           key: const ValueKey(false),
                //           onPressed: () {
                //             for (int i = 0;
                //                 i < orderProvider.orderedItems.length;
                //                 i++) {
                //               totalPriceToShow +=
                //                   orderProvider.orderedItems[i].totalPrice;
                //             }
                //             setState(() {
                //               _showTotalPrice = !_showTotalPrice;
                //             });
                //           },
                //           style: ElevatedButton.styleFrom(
                //             backgroundColor: blueColor,
                //           ),
                //           child: Text(
                //             '${AppLocalizations.of(context)!.totalPrice}?',
                //             style: const TextStyle(color: Colors.white),
                //           ),
                //         ),
                // ),
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
                    if ((_itemNameController.text.isEmpty &&
                            _weightController.text.isEmpty &&
                            _jyalaController.text.isEmpty &&
                            _jartiController.text.isEmpty &&
                            _stoneController.text.isEmpty) ||
                        _createOrderFormKey.currentState!.validate()) {
                      _showChoiceDialog(
                          orderProvider,
                          (_itemNameController.text.isEmpty &&
                                  _weightController.text.isEmpty &&
                                  _jyalaController.text.isEmpty &&
                                  _jartiController.text.isEmpty &&
                                  _stoneController.text.isEmpty)
                              ? true
                              : false);
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
