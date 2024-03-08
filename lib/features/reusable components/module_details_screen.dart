// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';

import '../../utils/global_variables.dart';
import '../../utils/widgets/custom_button.dart';
import '../orders/widget/order_details_custom_cards.dart';
import '../sales/screens/sale_details_custom_cards.dart';

class ModuleDetailsScreen extends StatelessWidget {
  final dynamic module;
  final Function deleteModule;
  final double totalModulePrice;
  final double totalOldModulePrice;
  final bool isSales;
  // final double totalOldJwelleryCharge;
  const ModuleDetailsScreen({
    Key? key,
    required this.module,
    required this.deleteModule,
    required this.totalModulePrice,
    required this.totalOldModulePrice,
    required this.isSales,
  }) : super(key: key);

  Future<void> _showChoiceDialog(BuildContext context) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.rightSlide,
      title: isSales
          ? AppLocalizations.of(context)!.deleteSale
          : AppLocalizations.of(context)!.deleteOrder,
      desc: '',
      btnOkText: AppLocalizations.of(context)!.yes,
      btnCancelText: AppLocalizations.of(context)!.no,
      btnOkColor: Colors.green,
      btnCancelColor: Colors.red,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        deleteModule();
        navigatorKey.currentState!.pop();
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSales
            ? Text(AppLocalizations.of(context)!.salesDetails)
            : Text(AppLocalizations.of(context)!.orderDetails),
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
              isSales
                  ? buildSalesUserInfoCard(
                      module, context, totalModulePrice, totalOldModulePrice)
                  : buildUserInfoCard(
                      module, context, totalModulePrice, totalOldModulePrice),
              const Gap(20),
              Text(
                isSales
                    ? AppLocalizations.of(context)!.soldItems
                    : AppLocalizations.of(context)!.orderedItems,
                style: const TextStyle(
                    fontSize: 20,
                    color: blueColor,
                    fontWeight: FontWeight.bold),
              ),
              isSales
                  ? buildSoldProductsList(module, context)
                  : buildOrderedItemsList(module, context),
              const Gap(20),
              if (isSales
                  ? module.oldProducts.isNotEmpty
                  : module.old_jwellery!.isNotEmpty) ...[
                Text(
                  AppLocalizations.of(context)!.oldJewelleryItem,
                  style: const TextStyle(
                      fontSize: 20,
                      color: blueColor,
                      fontWeight: FontWeight.bold),
                ),
                isSales
                    ? buildSoldOldProductsList(module, context)
                    : buildOldJwelleryList(module, context),
                const Gap(20),
              ],
              CustomButton(
                onPressed: () async {
                  _showChoiceDialog(context);
                },
                text: isSales
                    ? AppLocalizations.of(context)!.deleteSale
                    : AppLocalizations.of(context)!.deleteOrder,
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
