import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../provider/order_provider.dart';
import '../../../provider/sales_provider.dart';
import '../../../utils/form_validators.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/utils.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../reusable%20components/final_preview_screen.dart';
import '../models/old_jwellery_model.dart';

class OldJwelleryScreen extends StatefulWidget {
  static const String routeName = '/old-jwellery-screen';
  final bool isSales;
  const OldJwelleryScreen({super.key, required this.isSales});

  @override
  State<OldJwelleryScreen> createState() => _OldJwelleryScreenState();
}

class _OldJwelleryScreenState extends State<OldJwelleryScreen> {
  final GlobalKey<FormState> _oldJwelleryFormKey = GlobalKey<FormState>();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _stoneController = TextEditingController();
  final TextEditingController _stonePriceController = TextEditingController();
  // final TextEditingController _chargeController = TextEditingController();
  final TextEditingController _lossController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final _itemNamefocus = FocusNode();
  final _weightFocus = FocusNode();
  final _stoneFocus = FocusNode();
  final _stonePriceFocus = FocusNode();
  final _chargeFocus = FocusNode();
  final _lossFocus = FocusNode();
  final _rateFocus = FocusNode();
  late List<String> weight;
  late String selectedWeightType;
  late String lossWeightType;
  late List<String> types;
  late String selectedProductType;
  bool _dependenciesInitialized = false;
  double currentJwelleryPrice = 0.0;
  double totalPriceToShow = 0.0;
  bool _stonePriceFieldVisible = false;
  String customRate = "";
  bool _isSelectedTypeChanged = false;

  void calculateTotalPrice() {
    var (rselectedWeightType, _, _) = translatedTypes(
        context: context,
        selectedWeightType: selectedWeightType,
        selectedProductType: selectedProductType);

    var (rlossWeightType, _, _) = translatedTypes(
        context: context,
        selectedWeightType: lossWeightType,
        selectedProductType: selectedProductType);

    double weight = getWeightInGram(
      double.tryParse(_weightController.text.trim())!,
      rselectedWeightType ?? selectedWeightType,
    );
    double stonePrice = _stonePriceController.text.isEmpty
        ? 0.0
        : double.tryParse(_stonePriceController.text.trim())!;
    // double charge = _chargeController.text.isEmpty
    //     ? 0.0
    //     : double.tryParse(_chargeController.text.trim())!;
    double rate = double.tryParse(_rateController.text.trim())!;
    double loss = _lossController.text.isEmpty
        ? 0.0
        : getWeightInGram(
            double.tryParse(_lossController.text)!, rlossWeightType!);

    double totalPrice = getTotalPrice(
      weight: weight,
      rate: rate,
      loss: loss,
      // charge: charge,
      stonePrice: stonePrice,
    );

    setState(() {
      currentJwelleryPrice = totalPrice;
    });
  }

  void addOtherItem(OrderProvider orderProvider, SalesProvider salesProvider,
      bool isProceed) {
    var (rselectedWeightType, rselectedType, _) = translatedTypes(
        context: context,
        selectedWeightType: selectedWeightType,
        selectedProductType: selectedProductType);

    var (rlossWeightType, _, _) = translatedTypes(
        context: context,
        selectedWeightType: lossWeightType,
        selectedProductType: selectedProductType);

    double weight = getWeightInGram(
      double.tryParse(_weightController.text.trim())!,
      rselectedWeightType ?? selectedWeightType,
    );
    double? stonePrice = _stonePriceController.text.isEmpty
        ? null
        : double.tryParse(_stonePriceController.text.trim())!;

    // double? charge = _chargeController.text.isEmpty
    //     ? null
    //     : double.tryParse(_chargeController.text.trim())!;
    double rate = double.tryParse(_rateController.text.trim())!;
    double loss = _lossController.text.isEmpty
        ? 0.0
        : getWeightInGram(
            double.tryParse(_lossController.text)!, rlossWeightType!);

    double totalPrice = getTotalPrice(
      weight: weight,
      rate: rate,
      loss: loss,
      // charge: charge,
      stonePrice: stonePrice ?? 0.0,
    );

    OldJwellery oldJwellery = OldJwellery(
      itemName: _itemNameController.text.trim(),
      wt: weight,
      type: rselectedType ?? selectedProductType,
      stone:
          _stoneController.text.isEmpty ? null : _stoneController.text.trim(),
      stonePrice: stonePrice,
      // charge: charge,
      price: totalPrice,
      rate: rate,
      loss: loss,
    );

    if (widget.isSales) {
      salesProvider.addOldProduct(oldJwellery);
    } else {
      orderProvider.addOldJwellery(oldJwellery);
    }

    if (isProceed) {
      _oldJwelleryFormKey.currentState!.reset();

      Navigator.popAndPushNamed(context, OldJwelleryScreen.routeName,
          arguments: widget.isSales);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FinalPreviewScreen(
            isSales: widget.isSales,
          ),
        ),
      );
    } else {
      debugPrint("old jwellery screen called");
      debugPrint(widget.isSales.toString());
      Navigator.pushReplacementNamed(context, OldJwelleryScreen.routeName,
          arguments: widget.isSales);
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

      selectedProductType = AppLocalizations.of(context)!.chhapawal;

      selectedWeightType = AppLocalizations.of(context)!.gram;
      lossWeightType = selectedWeightType;
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
    _stoneController.dispose();
    _stonePriceController.dispose();
    // _chargeController.dispose();
    _lossController.dispose();
    _rateController.dispose();
    _itemNamefocus.dispose();
    _weightFocus.dispose();
    _stoneFocus.dispose();
    _stonePriceFocus.dispose();
    _chargeFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final salesProvider = Provider.of<SalesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.oldJewelleryItem,
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
                AppLocalizations.of(context)!.fillFormToShowOldJwellery,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: blueColor),
              ),
              const Gap(10),
              Form(
                key: _oldJwelleryFormKey,
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
                          _isSelectedTypeChanged = true;
                          customRate = goldRates[translatedTypes(
                                      context: context,
                                      selectedWeightType: selectedWeightType,
                                      selectedProductType: value)
                                  .$2]
                              .toString();
                          _rateController.text = customRate;
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
                            keyboardType: const TextInputType.numberWithOptions(
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
                      AppLocalizations.of(context)!.stone,
                      style: customTextDecoration()
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const Gap(5),
                    TextFormField(
                      controller: _stoneController,
                      focusNode: _stoneFocus,
                      onFieldSubmitted: (value) => _fieldFocusChange(
                          context,
                          _stoneFocus,
                          _stonePriceFieldVisible
                              ? _stonePriceFocus
                              : _rateFocus),
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
                            onFieldSubmitted: (value) => _fieldFocusChange(
                                context, _stonePriceFocus, _rateFocus),
                            keyboardType: const TextInputType.numberWithOptions(
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
                          const Gap(10),
                        ],
                      ),
                    ),
                    // Text(
                    //   AppLocalizations.of(context)!.charge,
                    //   style: customTextDecoration()
                    //       .copyWith(fontWeight: FontWeight.w600),
                    // ),
                    // const Gap(5),
                    // TextFormField(
                    //   controller: _chargeController,
                    //   focusNode: _chargeFocus,
                    //   onFieldSubmitted: (value) => _fieldFocusChange(
                    //       context, _chargeFocus, _rateFocus),
                    //   keyboardType: const TextInputType.numberWithOptions(
                    //       decimal: true),
                    //   textInputAction: TextInputAction.next,
                    //   cursorColor: blueColor,
                    //   decoration: customTextfieldDecoration(),
                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                    //   validator: (value) => validateCharge(value!, context),
                    //   onChanged: (value) => calculateTotalPrice(),
                    // ),
                    // const Gap(10),
                    Text(
                      AppLocalizations.of(context)!.rate,
                      style: customTextDecoration()
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const Gap(5),
                    TextFormField(
                      controller: _rateController
                        ..text = _isSelectedTypeChanged
                            ? customRate
                            : goldRates[translatedTypes(
                                        context: context,
                                        selectedWeightType: selectedWeightType,
                                        selectedProductType:
                                            selectedProductType)
                                    .$2]
                                .toString(),
                      focusNode: _rateFocus,
                      onFieldSubmitted: (value) =>
                          _fieldFocusChange(context, _rateFocus, _lossFocus),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      cursorColor: blueColor,
                      decoration: customTextfieldDecoration(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => validateRate(value!, context),
                      onChanged: (value) {
                        _rateController.text = value;
                        customRate = value;
                        _isSelectedTypeChanged = true;
                        calculateTotalPrice();
                      },
                    ),
                    const Gap(10),
                    Text(
                      AppLocalizations.of(context)!.loss,
                      style: customTextDecoration()
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _lossController,
                            focusNode: _lossFocus,
                            onFieldSubmitted: (value) => _lossFocus.unfocus(),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            textInputAction: TextInputAction.done,
                            cursorColor: blueColor,
                            decoration: customTextfieldDecoration(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              // validateWeight(_weightController.text, context);
                              // debugPrint(lossWeightType);
                              return validateLoss(
                                  _weightController.text,
                                  value!,
                                  selectedWeightType,
                                  lossWeightType,
                                  context);
                            },
                            onChanged: (value) => calculateTotalPrice(),
                          ),
                        ),
                        const Gap(10),
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            value: lossWeightType,
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
                                lossWeightType = value!;
                              });
                              calculateTotalPrice();
                            },
                            decoration: customTextfieldDecoration(),
                          ),
                        ),
                      ],
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
                      "रु${getNumberFormat(currentJwelleryPrice)}",
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              const Gap(10),
              CustomButton(
                onPressed: () {
                  if (_oldJwelleryFormKey.currentState!.validate()) {
                    addOtherItem(orderProvider, salesProvider, false);
                  }
                },
                text: AppLocalizations.of(context)!.addOtherItem,
                textColor: Colors.white,
                backgroundColor: blueColor,
              ),
              const Gap(10),
              CustomButton(
                onPressed: () {
                  if (_itemNameController.text.isEmpty &&
                          _weightController.text.isEmpty &&
                          _stoneController.text.isEmpty
                      // && _chargeController.text.isEmpty
                      ) {
                    // if (widget.isSales) {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) =>const CustomerDetailsForm(),
                    //     ),
                    //   );
                    // }else{
                    //   Navigator.pushNamed(
                    //     context, CustomerDetailsScreen.routeName);
                    // }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FinalPreviewScreen(isSales: widget.isSales),
                      ),
                    );
                  } else if (_oldJwelleryFormKey.currentState!.validate()) {
                    addOtherItem(orderProvider, salesProvider, true);
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
    );
  }
}
