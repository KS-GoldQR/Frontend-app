import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/features/home/screens/home_screen.dart';
import 'package:grit_qr_scanner/features/sales/service/sales_service.dart';
import 'package:grit_qr_scanner/features/sales/widgets/sold_status_card.dart';
import 'package:grit_qr_scanner/models/sales_model.dart';
import 'package:grit_qr_scanner/provider/sales_provider.dart';
import 'package:grit_qr_scanner/utils/form_validators.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../utils/global_variables.dart';
import '../../../utils/utils.dart';
import '../../../utils/widgets/custom_button.dart';

class CustomerDetailsForm extends StatefulWidget {
  const CustomerDetailsForm({super.key});

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
  final SalesService _salesService = SalesService();
  bool _isSelling = false;
  Map<SalesModel, bool> soldStatus = {};

  Future<void> sellProduct(
      BuildContext context, SalesProvider salesProvider) async {
    setState(() {
      _isSelling = true;
    });
    try {
      for (int i = 0; i < salesProvider.saleItems.length; i++) {
        SalesModel sales = salesProvider.saleItems[i];
        soldStatus[sales] = await _salesService.sellProduct(
          context: context,
          productId: sales.product.id,
          customerName: _nameController.text.trim(),
          customerPhone: _phoneController.text.trim(),
          customerAddress: _addressController.text.trim(),
          productTotalPrice: sales.price,
          jyala: sales.jyalaPercentage,
          jarti: sales.jartiPercentage,
        );
      }
    } catch (e) {
      debugPrint("inside catch block of sell items");
    } finally {
      if (mounted) {
        // Check if the widget is still mounted before updating the state
        setState(() {
          _isSelling = false;
        });
      }

      salesProvider.resetSaleItem();

      if (soldStatus.isNotEmpty && mounted) {
        debugPrint(soldStatus.length.toString());
        Navigator.popUntil(context, ModalRoute.withName(HomeScreen.routeName));
        Navigator.of(context).pushNamed(HomeScreen.routeName);
        showFullScreenDialog(context, soldStatus);
      }
    }
  }

  Future<void> showFullScreenDialog(
      BuildContext context, Map<SalesModel, bool> soldStatus) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SoldStatusCard(status: soldStatus)));
      },
    );
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
