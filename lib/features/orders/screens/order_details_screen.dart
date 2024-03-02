import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:grit_qr_scanner/utils/widgets/custom_button.dart';
import '../../../models/order_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widget/order_details_custom_cards.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Order order;
  final Function deleteOrder;
  final double totalOrderedPrice;
  final double totalOldJwelleryPrice;
  // final double totalOldJwelleryCharge;
  const OrderDetailsScreen({
    Key? key,
    required this.order,
    required this.deleteOrder,
    required this.totalOrderedPrice,
    required this.totalOldJwelleryPrice,
    //  required this.totalOldJwelleryCharge,
  }) : super(key: key);

  Future<void> _showChoiceDialog(BuildContext context) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.rightSlide,
      title: AppLocalizations.of(context)!.deleteOrder,
      desc: '',
      btnOkText: AppLocalizations.of(context)!.yes,
      btnCancelText: AppLocalizations.of(context)!.no,
      btnOkColor: Colors.green,
      btnCancelColor: Colors.red,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        deleteOrder();
        navigatorKey.currentState!.pop();
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.orderDetails),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.customerDetails,
                style: const TextStyle(
                    fontSize: 20,
                    color: blueColor,
                    fontWeight: FontWeight.bold),
              ),
              buildUserInfoCard(
                  order, context, totalOrderedPrice, totalOldJwelleryPrice),
              const Gap(20),
              Text(
                AppLocalizations.of(context)!.orderedItems,
                style: const TextStyle(
                    fontSize: 20,
                    color: blueColor,
                    fontWeight: FontWeight.bold),
              ),
              buildOrderedItemsList(order, context),
              const Gap(20),
              if (order.old_jwellery!.isNotEmpty) ...[
                Text(
                  AppLocalizations.of(context)!.oldJewelryItem,
                  style: const TextStyle(
                      fontSize: 20,
                      color: blueColor,
                      fontWeight: FontWeight.bold),
                ),
                buildOldJwelleryList(order, context),
                const Gap(20),
              ],
              CustomButton(
                onPressed: () async {
                  _showChoiceDialog(context);
                },
                text: AppLocalizations.of(context)!.deleteOrder,
                textColor: Colors.white,
                backgroundColor: blueColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
