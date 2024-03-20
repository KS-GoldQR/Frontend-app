import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import '../models/old_jwellery_model.dart';
import '../models/ordered_items_model.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:provider/provider.dart';

import '../../../models/customer_model.dart';
import '../../../provider/order_provider.dart';
import '../../../utils/custom_decorators.dart';
import '../../../utils/form_validators.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/utils.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../../services/order_service.dart';

class CustomerDetailsScreen extends StatefulWidget {
  static const String routeName = '/customer-details-screen';
  const CustomerDetailsScreen({super.key});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  final _customerDetailsFormKey = GlobalKey<FormState>();
  final GlobalKey _modalProgressHUDKeyCustomerDetails = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _advancePaymentController =
      TextEditingController();
  picker.NepaliDateTime expectedDeadline = picker.NepaliDateTime.now();
  final _nameFocus = FocusNode();
  final _addressFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _advancePaymentFocus = FocusNode();
  final OrderService _orderService = OrderService();
  bool _isSubmitting = false;

  void submitOrder() async {
    setState(() {
      _isSubmitting = true;
    });
    await _orderService.addOrder(context);
    setState(() {
      _isSubmitting = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    // final NepaliDateTime? picked = await showDatePicker(
    //   context: context,
    //   currentDate: NepaliDateTime.now(),
    //   initialDate: expectedDeadline,
    //   firstDate: NepaliDateTime(2000),
    //   lastDate: NepaliDateTime(2101),
    // );
    final picker.NepaliDateTime? picked = await picker.showAdaptiveDatePicker(
      context: context,
      initialDate: picker.NepaliDateTime.now(),
      firstDate: picker.NepaliDateTime(2000),
      lastDate: picker.NepaliDateTime(2100),
      // language: picker.Language.english,
      // dateOrder: _dateOrder, // for iOS only
      initialDatePickerMode: DatePickerMode.day, // for platform except iOS
    );
    if (picked != null && picked != expectedDeadline) {
      setState(() {
        expectedDeadline = picked;
      });
    }
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  double getOrderTotalPrice(List<OrderedItems> order) {
    double totalPrice = 0;
    for (int i = 0; i < order.length; i++) {
      totalPrice += order[i].totalPrice;
    }
    return totalPrice;
  }

  double getOldJwelleryTotalPrice(List<OldJwellery> order) {
    double totalPrice = 0;
    for (int i = 0; i < order.length; i++) {
      totalPrice += order[i].price;
    }
    return totalPrice;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _advancePaymentController.dispose();
    _nameFocus.dispose();
    _addressFocus.dispose();
    _phoneFocus.dispose();
    _advancePaymentFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return ModalProgressHUD(
      key: _modalProgressHUDKeyCustomerDetails,
      inAsyncCall: _isSubmitting,
      progressIndicator: const SpinKitDoubleBounce(
        color: blueColor,
      ),
      child: PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          orderProvider.resetCustomer();
          if (orderProvider.oldJwelleries.isNotEmpty) {
            orderProvider.oldJwelleries
                .removeAt(orderProvider.oldJwelleries.length - 1);
          }

          // if (orderProvider.orderedItems.isNotEmpty) {
          //   orderProvider.orderedItems
          //       .removeAt(orderProvider.orderedItems.length - 1);
          // }
          showSnackBar(
              title: AppLocalizations.of(context)!.customerDetailsCleared,
              contentType: ContentType.warning);
        },
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.customerDetails,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              centerTitle: false,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  children: [
                    const Gap(10),
                    Text(
                      AppLocalizations.of(context)!.fillCustomerDetails,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: blueColor),
                    ),
                    const Gap(10),
                    Form(
                      key: _customerDetailsFormKey,
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
                            onFieldSubmitted: (value) => _fieldFocusChange(
                                context, _nameFocus, _phoneFocus),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: blueColor,
                            decoration: customTextfieldDecoration(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                            onFieldSubmitted: (value) => _fieldFocusChange(
                                context, _addressFocus, _advancePaymentFocus),
                            keyboardType: TextInputType.streetAddress,
                            textInputAction: TextInputAction.next,
                            cursorColor: blueColor,
                            decoration: customTextfieldDecoration(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                validateAddress(value!, context),
                          ),
                          const Gap(10),
                          Text(
                            AppLocalizations.of(context)!.advancePayment,
                            style: customTextDecoration()
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const Gap(5),
                          TextFormField(
                            controller: _advancePaymentController,
                            focusNode: _advancePaymentFocus,
                            onFieldSubmitted: (value) =>
                                _advancePaymentFocus.unfocus(),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            textInputAction: TextInputAction.done,
                            cursorColor: blueColor,
                            decoration: customTextfieldDecoration(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                validateAdvancePayment(value!, context),
                          ),
                          const Gap(10),
                          Text(
                            AppLocalizations.of(context)!.deadline,
                            style: customTextDecoration()
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          TextButton.icon(
                            onPressed: () => _selectDate(context),
                            icon: const Icon(
                              Icons.calendar_month_outlined,
                              color: blueColor,
                            ),
                            label: Text(
                              formatDateTime(expectedDeadline),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(15),
                    CustomButton(
                      onPressed: () {
                        if (_customerDetailsFormKey.currentState!.validate()) {
                          orderProvider.setCustomerDetails(
                            Customer(
                              name: _nameController.text.trim(),
                              phone: _phoneController.text.trim(),
                              address: _addressController.text.trim(),
                              expectedDeadline: expectedDeadline,
                              advance: double.tryParse(
                                  _advancePaymentController.text)!,
                              remainingPayment: getOrderTotalPrice(
                                      orderProvider.orderedItems) -
                                  getOldJwelleryTotalPrice(
                                      orderProvider.oldJwelleries) -
                                  double.tryParse(
                                      _advancePaymentController.text)!,
                            ),
                          );

                          debugPrint(orderProvider.customer!.remainingPayment
                              .toString());
                          submitOrder();
                        }
                      },
                      text: AppLocalizations.of(context)!.submitOrder,
                      textColor: Colors.white,
                      backgroundColor: blueColor,
                    ),
                    const Gap(10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
