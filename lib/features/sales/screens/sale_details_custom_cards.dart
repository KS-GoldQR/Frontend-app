import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../models/sales_model.dart';
import '../../../utils/widgets/build_row_info.dart';

Widget buildSalesUserInfoCard(SalesModel sale, BuildContext context,
    double totalProductPrice, double totalOldProductPrice) {
  return Card(
    elevation: 5.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildInfoRow(AppLocalizations.of(context)!.name, sale.customerName),
          buildInfoRow(
              AppLocalizations.of(context)!.contactNumber, sale.customerPhone),
          buildInfoRow(AppLocalizations.of(context)!.soldItemPrice,
              NumberFormat('#,##,###.00').format(totalProductPrice)),
          buildInfoRow(AppLocalizations.of(context)!.soldOldItemPrice,
              NumberFormat('#,##,###.00').format(totalOldProductPrice)),
          buildInfoRow(
              AppLocalizations.of(context)!.totalPrice,
              NumberFormat('#,##,###.00')
                  .format(totalProductPrice - totalOldProductPrice)),
          buildInfoRow(AppLocalizations.of(context)!.soldDate,
              DateFormat.yMMMd().format(sale.createdAt)),
        ],
      ),
    ),
  );
}

Widget buildSoldProductsList(SalesModel sale, BuildContext context) {
  return Card(
    elevation: 5.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sale.products?.length ?? 0,
        itemBuilder: (context, index) {
          final soldItem = sale.products![index];

          return Column(
            children: [
              buildInfoRow(
                soldItem.name,
                "${AppLocalizations.of(context)!.type}: ${soldItem.type == "Chhapawal" ? AppLocalizations.of(context)!.chhapawal : soldItem.type == "Tejabi" ? AppLocalizations.of(context)!.tejabi : AppLocalizations.of(context)!.asalChandi} \n ${AppLocalizations.of(context)!.weight}: ${soldItem.weight} ${AppLocalizations.of(context)!.gram} \n ${AppLocalizations.of(context)!.price}: ${NumberFormat('#,##,###.00').format(soldItem.amount)}",
              ),
              if (index != sale.products!.length - 1)
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

Widget buildSoldOldProductsList(SalesModel sale, BuildContext context) {
  return Card(
    elevation: 5.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sale.oldProducts?.length ?? 0,
        itemBuilder: (context, index) {
          final oldProduct = sale.oldProducts![index];

          return Column(
            children: [
              buildInfoRow(
                  oldProduct.itemName,
                  "${AppLocalizations.of(context)!.type}: ${oldProduct.type == "Chhapawal" ? AppLocalizations.of(context)!.chhapawal : oldProduct.type == "Tejabi" ? AppLocalizations.of(context)!.tejabi : AppLocalizations.of(context)!.asalChandi} \n ${AppLocalizations.of(context)!.weight}: ${oldProduct.wt} ${AppLocalizations.of(context)!.gram} \n ${AppLocalizations.of(context)!.price}: ${NumberFormat('#,##,###.00').format(oldProduct.price)} \n ${AppLocalizations.of(context)!.rate}: ${NumberFormat('#,##,###.00').format(oldProduct.rate)}"),
              if (index != sale.oldProducts!.length - 1)
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
