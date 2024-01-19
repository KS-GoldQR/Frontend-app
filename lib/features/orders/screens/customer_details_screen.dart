import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/features/orders/services/order_service.dart';
import 'package:grit_qr_scanner/models/customer_model.dart';
import 'package:grit_qr_scanner/provider/order_provider.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../utils/global_variables.dart';
import '../../../utils/utils.dart';
import '../../../utils/widgets/custom_button.dart';

class CustomerDetailsScreen extends StatefulWidget {
  static const String routeName = '/customer-details-screen';
  const CustomerDetailsScreen({super.key});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  final _customerDetailsFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _advancePaymentController =
      TextEditingController();
  DateTime expectedDeadline = DateTime.now();
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
    final DateTime? picked = await showDatePicker(
      context: context,
      helpText: "Choose Expected Deadline",
      currentDate: DateTime.now(),
      initialDate: expectedDeadline,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != expectedDeadline) {
      setState(() {
        expectedDeadline = picked;
      });
    }
  }

  String formatDateTime(DateTime date) {
    final dateTime = DateTime(date.year, date.month, date.day);
    return DateFormat.yMMMMd().format(dateTime);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _advancePaymentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: _isSubmitting,
      progressIndicator: const SpinKitDoubleBounce(
        color: blueColor,
      ),
      child: PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          orderProvider.resetCustomer();
          if (orderProvider.oldJewelries.isNotEmpty) {
            orderProvider.oldJewelries
                .removeAt(orderProvider.oldJewelries.length - 1);
          }

          if (orderProvider.orderedItems.isNotEmpty) {
            orderProvider.orderedItems
                .removeAt(orderProvider.orderedItems.length - 1);
          }
          showSnackBar(
              title: "Customer Details Cleared",
              message: "",
              contentType: ContentType.warning);
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Customer Details",
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
                    key: _customerDetailsFormKey,
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
                          cursorColor: blueColor,
                          decoration: customTextfieldDecoration(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "address cannot be empty!";
                            }
                            return null;
                          },
                        ),
                        const Gap(10),
                        Text(
                          "Advance Payment",
                          style: customTextDecoration()
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        const Gap(5),
                        TextFormField(
                          controller: _advancePaymentController,
                          cursorColor: blueColor,
                          decoration: customTextfieldDecoration(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "advance payment cannot be empty!";
                            }

                            if (double.tryParse(value) == null) {
                              return "enter a valid number";
                            }

                            if (double.tryParse(value)! < 0) {
                              return "advance cannot be less than 0";
                            }
                            return null;
                          },
                        ),
                        const Gap(10),
                        Text(
                          "Expected Deadline",
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
                          ),
                        );
                        submitOrder();
                      }
                    },
                    text: "Submit Order",
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
    );
  }
}
