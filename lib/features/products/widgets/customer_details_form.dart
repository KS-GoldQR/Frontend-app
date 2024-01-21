import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/features/products/services/product_service.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../models/product_model.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/utils.dart';
import '../../../utils/widgets/custom_button.dart';

class CustomerDetailsForm extends StatefulWidget {
  final Product product;
  final double rate;
  const CustomerDetailsForm({super.key, required this.product, required this.rate});

  @override
  State<CustomerDetailsForm> createState() => _CustomerDetailsFormState();
}

class _CustomerDetailsFormState extends State<CustomerDetailsForm> {
  final _customerDetailsFormFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _nameFocus = FocusNode();
  final _addressFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final ProductService _productService = ProductService();
  bool _isSelling = false;

  Future<void> sellProduct(BuildContext context) async {
    setState(() {
      _isSelling = true;
    });
    await _productService.sellProduct(
      context: context,
      productId: widget.product.id,
      customerName: _nameController.text.trim(),
      customerPhone: _phoneController.text.trim(),
      customerAddress: _addressController.text.trim(),
    );
    setState(() {
      _isSelling = false;
    });
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _nameFocus.dispose();
    _addressFocus.dispose();
    _phoneFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isSelling,
      progressIndicator: const SpinKitChasingDots(
        color: blueColor,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sell Product"),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              children: [
                const Text(
                  "Fill Customer Details to Sell product",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: blueColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(20),
                Form(
                  key: _customerDetailsFormFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name: ",
                        style: customTextDecoration()
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Gap(5),
                      TextFormField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        onFieldSubmitted: (value) =>
                            _fieldFocusChange(context, _nameFocus, _phoneFocus),
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
                        "Phone Number",
                        style: customTextDecoration()
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Gap(5),
                      TextFormField(
                        controller: _phoneController,
                        focusNode: _phoneFocus,
                        onFieldSubmitted: (value) => _fieldFocusChange(
                            context, _phoneFocus, _addressFocus),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        cursorColor: blueColor,
                        decoration: customTextfieldDecoration(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "phone number cannot be empty!";
                          }

                          if (value.length != 10) {
                            return "enter valid phone number";
                          }
                          return null;
                        },
                      ),
                      const Gap(10),
                      Text(
                        "Address",
                        style: customTextDecoration()
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Gap(5),
                      TextFormField(
                        controller: _addressController,
                        focusNode: _addressFocus,
                        onFieldSubmitted: (value) => _addressFocus.unfocus(),
                        keyboardType: TextInputType.streetAddress,
                        textInputAction: TextInputAction.done,
                        cursorColor: blueColor,
                        decoration: customTextfieldDecoration(),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "address cannot be empty!";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const Gap(25),
                CustomButton(
                    onPressed: () {
                      if (_customerDetailsFormFormKey.currentState!
                          .validate()) {
                        sellProduct(context);
                      }
                    },
                    text: "Sell Product",
                    backgroundColor: blueColor,
                    textColor: Colors.white),
                const Gap(10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
