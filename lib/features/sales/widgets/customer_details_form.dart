// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../models/sales_model.dart';
import '../../../provider/sales_provider.dart';
import '../../../utils/custom_decorators.dart';
import '../../../utils/form_validators.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../services/sales_service.dart';

class CustomerDetailsForm extends StatefulWidget {
  const CustomerDetailsForm({super.key});

  @override
  State<CustomerDetailsForm> createState() => _CustomerDetailsFormState();
}

class _CustomerDetailsFormState extends State<CustomerDetailsForm> {
  final _customerDetailsFormFormKey = GlobalKey<FormState>();
  final GlobalKey _modalProgressHUDKeyCust = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _nameFocus = FocusNode();
  final _addressFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final SalesService _salesService = SalesService();
  bool _isSelling = false;
  Map<SalesModel, bool> soldStatus = {};

  Future<void> sellProduct(
      BuildContext context, SalesProvider salesProvider) async {
    setState(() {
      _isSelling = true;
    });
    try {
      await _salesService.sellProduct(
          context: context,
          customerName: _nameController.text.trim(),
          customerPhone: _phoneController.text.trim(),
          products: salesProvider.products,
          oldProducts: salesProvider.oldProducts);
    } catch (e) {
      debugPrint("error here occursing");
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        // Check if the widget is still mounted before updating the state
        setState(() {
          _isSelling = false;
        });
      }
    }
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
    final salesProvider = Provider.of<SalesProvider>(context);
    return ModalProgressHUD(
      key: _modalProgressHUDKeyCust,
      inAsyncCall: _isSelling,
      progressIndicator: const SpinKitChasingDots(
        color: blueColor,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.sellItem),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              children: [
                const Gap(20),
                Text(
                  AppLocalizations.of(context)!.fillCustomerDetails,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                        AppLocalizations.of(context)!.name,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => validateName(value!, context),
                      ),
                      const Gap(10),
                      Text(
                        AppLocalizations.of(context)!.contactNumber,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                            validateContactNumber(value!, context),
                      ),
                      const Gap(10),
                      Text(
                        AppLocalizations.of(context)!.address,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => validateAddress(value!, context),
                      ),
                    ],
                  ),
                ),
                const Gap(25),
                CustomButton(
                    onPressed: () {
                      if (_customerDetailsFormFormKey.currentState!
                          .validate()) {
                        sellProduct(context, salesProvider);
                      }
                    },
                    text: AppLocalizations.of(context)!.sellItem,
                    backgroundColor: blueColor,
                    textColor: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
