import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import '../../../provider/order_provider.dart';
import '../../../utils/utils.dart';
import 'package:intl/intl.dart';
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
      ? const Center(child: Text("No Items are ordered"))
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
                      children: [
                        Expanded(
                          child: buildInfoRow(
                            order.itemName,
                            "${AppLocalizations.of(context)!.type}: ${order.type == "Chhapawal" ? AppLocalizations.of(context)!.chhapawal : order.type == "Tejabi" ? AppLocalizations.of(context)!.tejabi : AppLocalizations.of(context)!.asalChandi} \n ${AppLocalizations.of(context)!.weight}: ${order.wt} ${AppLocalizations.of(context)!.gram} \n ${AppLocalizations.of(context)!.jyala}: रु${getNumberFormat(order.jyala)} \n ${AppLocalizations.of(context)!.jarti}: ${getNumberFormat(order.jarti)} ${order.jartiType == "Laal" ? AppLocalizations.of(context)!.laal : AppLocalizations.of(context)!.percentage} \n ${AppLocalizations.of(context)!.price}: रु${getNumberFormat(order.totalPrice)}",
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
      ? const Center(child: Text("No old Items are ordered"))
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
                      children: [
                        Expanded(
                          child: buildInfoRow(
                            order.itemName,
                            "${AppLocalizations.of(context)!.type}: ${order.type == "Chhapawal" ? AppLocalizations.of(context)!.chhapawal : order.type == "Tejabi" ? AppLocalizations.of(context)!.tejabi : AppLocalizations.of(context)!.asalChandi} \n ${AppLocalizations.of(context)!.weight}: ${order.wt} ${AppLocalizations.of(context)!.gram} \n ${AppLocalizations.of(context)!.rate}: ${order.rate} \n ${AppLocalizations.of(context)!.loss}: ${order.loss} \n ${AppLocalizations.of(context)!.price}: ${NumberFormat('#,##,###.00').format(order.price)}",
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
