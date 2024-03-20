import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';

import '../../../provider/sales_provider.dart';
import '../../../utils/custom_decorators.dart';
import '../../../utils/global_variables.dart';
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

  return sales.isEmpty
      ? Center(child: Text(AppLocalizations.of(context)!.noProductHasBeenSold))
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          sale.name,
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
                            sale.type == "Chhapawal"
                                ? AppLocalizations.of(context)!.chhapawal
                                : sale.type == "Tejabi"
                                    ? AppLocalizations.of(context)!.tejabi
                                    : AppLocalizations.of(context)!.asalChandi),
                        buildInfoRow(AppLocalizations.of(context)!.weight,
                            "${sale.weight} ${AppLocalizations.of(context)!.gram}"),
                        buildInfoRow(AppLocalizations.of(context)!.jyala,
                            "रु ${sale.jyala}"),
                        buildInfoRow(AppLocalizations.of(context)!.jarti,
                            "${sale.jarti} ${sale.jartiType == "%" ? AppLocalizations.of(context)!.percentage : AppLocalizations.of(context)!.laal} "),
                        buildInfoRow(AppLocalizations.of(context)!.actualPrice,
                            "रु ${getNumberFormat(getTotalPrice(weight: sale.weight, rate: goldRates[sale.type]!))}",
                            isPrice: true),
                        buildInfoRow(AppLocalizations.of(context)!.price,
                            "रु ${getNumberFormat(sale.amount)}",
                            isPrice: true),
                        const Gap(10),
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
      ? Center(child: Text(AppLocalizations.of(context)!.oldJwelleryListEmpty))
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          sale.itemName,
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
                            sale.type == "Chhapawal"
                                ? AppLocalizations.of(context)!.chhapawal
                                : sale.type == "Tejabi"
                                    ? AppLocalizations.of(context)!.tejabi
                                    : AppLocalizations.of(context)!.asalChandi),
                        buildInfoRow(AppLocalizations.of(context)!.weight,
                            "${sale.wt} ${AppLocalizations.of(context)!.gram}"),
                        buildInfoRow(AppLocalizations.of(context)!.rate,
                            "रु ${sale.rate}"),
                        buildInfoRow(AppLocalizations.of(context)!.loss,
                            "रु ${sale.loss}"),
                        buildInfoRow(AppLocalizations.of(context)!.price,
                            "रु ${getNumberFormat(sale.price)}",
                            isPrice: true),
                        const Gap(10),
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
