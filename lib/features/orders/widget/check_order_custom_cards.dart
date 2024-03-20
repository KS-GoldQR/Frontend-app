import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../provider/order_provider.dart';
import '../../../utils/custom_decorators.dart';
import '../../../utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:remixicon/remixicon.dart';

import '../../../utils/widgets/build_row_info.dart';

Widget buildCheckOrderedItems(BuildContext context) {
  final orderProvider = Provider.of<OrderProvider>(context, listen: false);
  final orders = orderProvider.orderedItems;

  Future<void> showChoiceDialogDelete(BuildContext context, int index) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.rightSlide,
      title: AppLocalizations.of(context)!.areYouSure,
      desc: '',
      btnOkText: AppLocalizations.of(context)!.yes,
      btnCancelText: AppLocalizations.of(context)!.no,
      btnOkColor: Colors.green,
      btnCancelColor: Colors.red,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        orderProvider.removeOrderedItemAt(index);
      },
    ).show();
  }

  return orders.isEmpty
      ? Center(child: Text(AppLocalizations.of(context)!.noProductsFound))
      : Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          order.itemName,
                          style: customTextDecoration().copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await showChoiceDialogDelete(context, index);
                          },
                          icon: const Icon(
                            Remix.delete_bin_2_line,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        buildInfoRow(
                            AppLocalizations.of(context)!.type,
                            order.type == "Chhapawal"
                                ? AppLocalizations.of(context)!.chhapawal
                                : order.type == "Tejabi"
                                    ? AppLocalizations.of(context)!.tejabi
                                    : AppLocalizations.of(context)!.asalChandi),
                        buildInfoRow(AppLocalizations.of(context)!.weight,
                            "${order.wt} ${AppLocalizations.of(context)!.gram}"),
                        buildInfoRow(AppLocalizations.of(context)!.jyala,
                            "रु ${order.jyala}"),
                        buildInfoRow(AppLocalizations.of(context)!.jarti,
                            "${order.jarti} ${order.jartiType == "%" ? AppLocalizations.of(context)!.percentage : AppLocalizations.of(context)!.laal} "),
                        buildInfoRow(AppLocalizations.of(context)!.price,
                            "रु ${getNumberFormat(order.totalPrice)}",
                            isPrice: true),
                        const Gap(10),
                      ],
                    ),
                    if (index != orders.length - 1)
                      const Divider(
                        color: Color(0xFFBDBCBC),
                        thickness: 1,
                        height: 1,
                        indent: 50,
                        endIndent: 50,
                      ),
                  ],
                );
              },
            ),
          ),
        );
}

Widget buildCheckOldJwelleryItems(BuildContext context) {
  final orderProvider = Provider.of<OrderProvider>(context);
  final orders = orderProvider.oldJwelleries;

  Future<void> showChoiceDialogDelete(BuildContext context, int index) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.rightSlide,
      title: AppLocalizations.of(context)!.areYouSure,
      desc: '',
      btnOkText: AppLocalizations.of(context)!.yes,
      btnCancelText: AppLocalizations.of(context)!.no,
      btnOkColor: Colors.green,
      btnCancelColor: Colors.red,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        orderProvider.removeOldJwelleryItemAt(index);
      },
    ).show();
  }

  return orders.isEmpty
      ? Center(child: Text(AppLocalizations.of(context)!.noProductsFound))
      : Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          order.itemName,
                          style: customTextDecoration().copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await showChoiceDialogDelete(context, index);
                          },
                          icon: const Icon(
                            Remix.delete_bin_2_line,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        buildInfoRow(
                            AppLocalizations.of(context)!.type,
                            order.type == "Chhapawal"
                                ? AppLocalizations.of(context)!.chhapawal
                                : order.type == "Tejabi"
                                    ? AppLocalizations.of(context)!.tejabi
                                    : AppLocalizations.of(context)!.asalChandi),
                        buildInfoRow(AppLocalizations.of(context)!.weight,
                            "${order.wt} ${AppLocalizations.of(context)!.gram}"),
                        buildInfoRow(AppLocalizations.of(context)!.rate,
                            "रु ${order.rate}"),
                        buildInfoRow(AppLocalizations.of(context)!.loss,
                            "रु ${order.loss}"),
                        buildInfoRow(AppLocalizations.of(context)!.price,
                            "रु ${getNumberFormat(order.price)}",
                            isPrice: true),
                        const Gap(10),
                      ],
                    ),
                    if (index != orders.length - 1)
                      const Divider(
                        color: Color(0xFFBDBCBC),
                        thickness: 1,
                        height: 1,
                        indent: 50,
                        endIndent: 50,
                      ),
                  ],
                );
              },
            ),
          ),
        );
}
