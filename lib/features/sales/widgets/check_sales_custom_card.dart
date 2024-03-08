import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

import '../../../provider/sales_provider.dart';
import '../../../utils/utils.dart';
import '../../../utils/widgets/build_row_info.dart';

Widget buildCheckSoldProduct(BuildContext context) {
  final salesProvider = Provider.of<SalesProvider>(context, listen: false);
  final sales = salesProvider.products;

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
             salesProvider.removeProductItemAt(index);
      },
    ).show();
  }

  return  sales.isEmpty
      ? const Center(child: Text("No items are sold"))
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
              itemCount: sales.length,
              itemBuilder: (context, index) {
                final sale = sales[index];

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: buildInfoRow(
                            sale.name,
                            "${AppLocalizations.of(context)!.type}: ${sale.type == "Chhapawal" ? AppLocalizations.of(context)!.chhapawal : sale.type == "Tejabi" ? AppLocalizations.of(context)!.tejabi : AppLocalizations.of(context)!.asalChandi} \n ${AppLocalizations.of(context)!.weight}: ${sale.weight} ${AppLocalizations.of(context)!.gram} \n ${AppLocalizations.of(context)!.jyala}: रु${getNumberFormat(sale.jyala)} \n ${AppLocalizations.of(context)!.jarti}: ${getNumberFormat(sale.jarti)} ${sale.jartiType == "Laal" ? AppLocalizations.of(context)!.laal : AppLocalizations.of(context)!.percentage} \n ${AppLocalizations.of(context)!.price}: रु${getNumberFormat(sale.amount)}",
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
                    if (index != sales.length - 1)
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

Widget buildCheckSoldOldProduct(BuildContext context) {
  final salesProvider = Provider.of<SalesProvider>(context);
  final sales = salesProvider.oldProducts;

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
        salesProvider.removeOldProductItemAt(index);
      },
    ).show();
  }

  return sales.isEmpty
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
              itemCount: sales.length,
              itemBuilder: (context, index) {
                final sale = sales[index];

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: buildInfoRow(
                            sale.itemName,
                            "${AppLocalizations.of(context)!.type}: ${sale.type == "Chhapawal" ? AppLocalizations.of(context)!.chhapawal : sale.type == "Tejabi" ? AppLocalizations.of(context)!.tejabi : AppLocalizations.of(context)!.asalChandi} \n ${AppLocalizations.of(context)!.weight}: ${sale.wt} ${AppLocalizations.of(context)!.gram} \n ${AppLocalizations.of(context)!.rate}: ${sale.rate} \n ${AppLocalizations.of(context)!.loss}: ${sale.loss} \n ${AppLocalizations.of(context)!.price}: ${NumberFormat('#,##,###.00').format(sale.price)}",
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
                    if (index != sales.length - 1)
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
