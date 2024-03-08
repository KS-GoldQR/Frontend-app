import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../utils/form_validators.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/utils.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _jyalaController = TextEditingController();
  final TextEditingController _jartiController = TextEditingController();
  final TextEditingController _stonePriceController = TextEditingController();
  late List<String> weight;
  late String selectedWeightType;
  late String selectedJartiWeightType;
  late List<String> jartiWeightTypeList;
  late List<String> types;
  late String selectedProductType;
  bool _dependenciesInitialized = false;
  late String jartiWeightType;
  double currentOrderPrice = 0.0;

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

  void calculateTotalPrice() {
    var (rselectedWeightType, rselectedType, rselectedJartiWeightType) = translatedTypes(
        context: context,
        selectedWeightType: selectedWeightType,
        selectedProductType: selectedProductType, selectedJartiWeightType: selectedJartiWeightType);

    double weight = getWeightInGram(
      double.tryParse(_weightController.text.trim())!,
      rselectedWeightType ?? selectedWeightType,
    );
    double jyala = double.tryParse(_jyalaController.text.trim())!;
    double jarti = getWeightInGram(
        double.tryParse(_jartiController.text.trim())!,
        rselectedJartiWeightType!);
    double stonePrice =
        double.tryParse(_stonePriceController.text.trim()) ?? 0.0;
    double totalPrice = getTotalPrice(
      weight: weight,
      rate: goldRates[rselectedType ?? selectedProductType]!,
      jyala: jyala,
      jarti: jarti,
      stonePrice: stonePrice,
      jartiWeightType: rselectedJartiWeightType
    );

    setState(() {
      currentOrderPrice = totalPrice;
    });
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
    _weightController.dispose();
    _jyalaController.dispose();
    _jartiController.dispose();
    _stonePriceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.calculator,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            children: [
              const Gap(10),
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      "${AppLocalizations.of(context)!.jyala} ",
                      style: customTextDecoration()
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const Gap(5),
                    TextFormField(
                      controller: _jyalaController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      cursorColor: blueColor,
                      decoration: customTextfieldDecoration(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => validateJyala(value!, context),
                      onChanged: (value) => calculateTotalPrice(),
                    ),
                    const Gap(10),
                    Text(
                      "${AppLocalizations.of(context)!.jarti} ",
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
                            keyboardType: const TextInputType.numberWithOptions(
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
                            value: jartiWeightType,
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
                                jartiWeightType = value!;
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
                      AppLocalizations.of(context)!.stonePrice,
                      style: customTextDecoration()
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const Gap(5),
                    TextFormField(
                      controller: _stonePriceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.done,
                      cursorColor: blueColor,
                      decoration: customTextfieldDecoration(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => validateStonePrice(value!, context),
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
                      "रु${NumberFormat('#,##,###.00').format(currentOrderPrice)}",
                      style: const TextStyle(
                        fontSize: 20,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
