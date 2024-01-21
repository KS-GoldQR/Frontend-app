import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/features/orders/models/ordered_items_model.dart';
import 'package:grit_qr_scanner/features/orders/screens/customer_details_screen.dart';
import 'package:grit_qr_scanner/features/orders/screens/old_jwellery_screen.dart';
import 'package:grit_qr_scanner/provider/order_provider.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:grit_qr_scanner/utils/widgets/custom_button.dart';
import 'package:provider/provider.dart';

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
  List<String> weight = ['Tola', 'Gram', 'Laal'];
  String selectedWeightType = 'Gram';
  List<String> types = ['Chapawala', 'Tejabi', 'Asal_chaadhi'];
  String selectedType = 'Chapawala';
  double currentOrderPrice = 0.0;
  double totalPriceToShow = 0.0;
  Map<String, double> goldRates = {};

  void _showChoiceDialog() {
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
          Navigator.pushNamed(context, CustomerDetailsScreen.routeName);
        },
        btnOkOnPress: () {
          Navigator.pushNamed(context, OldJwelleryScreen.routeName);
        },
      ).show();
    });
  }

  void calculateTotalPrice() {
    double weight = getWeight(
      double.tryParse(_weightController.text.trim())!,
      selectedWeightType,
    );
    double jyala = double.tryParse(_jyalaController.text.trim())!;
    double jarti = double.tryParse(_jartiController.text.trim())!;
    double stonePrice = double.tryParse(_stonePriceController.text.trim())!;
    double totalPrice = getTotalPrice(
      weight: weight,
      rate: goldRates[selectedType]!,
      jyalaPercent: jyala,
      jartiPercent: jarti,
      stonePrice: stonePrice,
    );

    setState(() {
      currentOrderPrice = totalPrice;
    });
  }

  void addOtherItem(OrderProvider orderProvider, bool isProceed) {
    double weight = getWeight(
      double.tryParse(_weightController.text.trim())!,
      selectedWeightType,
    );
    double jyala = double.tryParse(_jyalaController.text.trim())!;
    double jarti = double.tryParse(_jartiController.text.trim())!;
    double stonePrice = double.tryParse(_stonePriceController.text.trim())!;
    double totalPrice = getTotalPrice(
      weight: weight,
      rate: goldRates[selectedType]!,
      jyalaPercent: jyala,
      jartiPercent: jarti,
      stonePrice: stonePrice,
    );

    OrderedItems orderedItem = OrderedItems(
      itemName: _itemNameController.text.trim(),
      wt: weight,
      type: selectedType,
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
  void initState() {
    getGoldRates();
    super.initState();
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
          title: const Text(
            "Create Order",
            style: TextStyle(color: blueColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              children: [
                Form(
                  key: _createOrderFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Item Name: ",
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
                        "Type",
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
                          });
                        },
                        decoration: customTextfieldDecoration(),
                      ),
                      const Gap(10),
                      Text(
                        "Weight ",
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
                                });
                              },
                              decoration: customTextfieldDecoration(),
                            ),
                          ),
                        ],
                      ),
                      const Gap(10),
                      Text(
                        "Jyala (%) ",
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "jyala cannot be empty!";
                          }

                          if (double.tryParse(value) == null) {
                            return "enter a valid number";
                          }

                          if (double.tryParse(value)! < 0) {
                            return "jyala cannot be negative/zero";
                          }

                          return null;
                        },
                        onChanged: (value) => calculateTotalPrice(),
                      ),
                      const Gap(10),
                      Text(
                        "Jarti (%) ",
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "jarti cannot be empty!";
                          }

                          if (double.tryParse(value) == null) {
                            return "enter a valid number";
                          }

                          if (double.tryParse(value)! < 0) {
                            return "jarti cannot be negative/zero";
                          }

                          return null;
                        },
                        onChanged: (value) => calculateTotalPrice(),
                      ),
                      const Gap(10),
                      Text(
                        "Stone",
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
                      ),
                      const Gap(10),
                      Text(
                        "Stone Price",
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
                      const Text(
                        "Current Order Price: ",
                        style: TextStyle(
                            color: greyColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Text(
                        currentOrderPrice.toString(),
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
                              'Total Price: \$$totalPriceToShow',
                              key: const ValueKey(true),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const Text(
                              'Note: Total price is excluding current order price',
                              style: TextStyle(
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
                          child: const Text(
                            'Total Price?',
                            style: TextStyle(color: Colors.white),
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
                  text: "Add Other Item",
                  textColor: Colors.white,
                  backgroundColor: blueColor,
                ),
                const Gap(10),
                CustomButton(
                  onPressed: () {
                    if (_createOrderFormKey.currentState!.validate()) {
                      addOtherItem(orderProvider, true);
                      _showChoiceDialog();
                    }
                  },
                  text: "Proceed",
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
