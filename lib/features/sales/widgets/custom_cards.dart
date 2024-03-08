import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/provider/sales_provider.dart';
import 'package:grit_qr_scanner/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

import '../../../utils/widgets/build_row_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget buildSalesItemsList(BuildContext context) {
  final salesProvider = Provider.of<SalesProvider>(context);
  final products = salesProvider.products;

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

  return products.isEmpty
      ? Text(AppLocalizations.of(context)!.noProductToSell)
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
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: buildInfoRow(
                            product.name,
                            "${AppLocalizations.of(context)!.type}: ${product.type == "Chhapawal" ? AppLocalizations.of(context)!.chhapawal : product.type == "Tejabi" ? AppLocalizations.of(context)!.tejabi : AppLocalizations.of(context)!.asalChandi} \n ${AppLocalizations.of(context)!.weight}: ${product.weight} ${AppLocalizations.of(context)!.gram} \n ${AppLocalizations.of(context)!.jyala}: रु${product.jyala}\n ${AppLocalizations.of(context)!.jarti}: ${product.jarti} ${product.jartiType == "%" ? AppLocalizations.of(context)!.percentage : AppLocalizations.of(context)!.laal} \n ${AppLocalizations.of(context)!.price}: ${getNumberFormat(product.amount)}",
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
                    if (index != products.length - 1)
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
