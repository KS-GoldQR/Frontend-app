import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import '../../../utils/utils.dart';

import '../../../models/sales_model.dart';
import '../../../utils/custom_decorators.dart';
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
              AppLocalizations.of(context)!.contactNumber,sale.customerPhone ?? ""),
          buildInfoRow(AppLocalizations.of(context)!.soldItemPrice,
              "रु ${getNumberFormat(totalProductPrice)}",
              isPrice: true),
          buildInfoRow(AppLocalizations.of(context)!.soldOldItemPrice,
              "रु ${getNumberFormat(totalOldProductPrice)}",
              isPrice: true),
          buildInfoRow(AppLocalizations.of(context)!.totalPrice,
              "रु ${getNumberFormat(totalProductPrice - totalOldProductPrice)}",
              isPrice: true),
          buildInfoRow(AppLocalizations.of(context)!.soldDate,
              formatDateTime(sale.createdAt)),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                soldItem.name,
                style: customTextDecoration().copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Column(
                children: [
                  buildInfoRow(
                      AppLocalizations.of(context)!.type,
                      soldItem.type == "Chhapawal"
                          ? AppLocalizations.of(context)!.chhapawal
                          : soldItem.type == "Tejabi"
                              ? AppLocalizations.of(context)!.tejabi
                              : AppLocalizations.of(context)!.asalChandi),
                  buildInfoRow(AppLocalizations.of(context)!.weight,
                      "${soldItem.weight} ${AppLocalizations.of(context)!.gram}"),
                  buildInfoRow(AppLocalizations.of(context)!.price,
                      "रु ${getNumberFormat(soldItem.amount)}",
                      isPrice: true),
                  const Gap(10),
                ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AutoSizeText(
                    oldProduct.itemName,
                    style: customTextDecoration().copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  buildInfoRow(
                      AppLocalizations.of(context)!.type,
                      oldProduct.type == "Chhapawal"
                          ? AppLocalizations.of(context)!.chhapawal
                          : oldProduct.type == "Tejabi"
                              ? AppLocalizations.of(context)!.tejabi
                              : AppLocalizations.of(context)!.asalChandi),
                  buildInfoRow(AppLocalizations.of(context)!.weight,
                      "${oldProduct.wt} ${AppLocalizations.of(context)!.gram}"),
                  buildInfoRow(AppLocalizations.of(context)!.rate,
                      "रु ${oldProduct.rate}"),
                  buildInfoRow(AppLocalizations.of(context)!.price,
                      "रु ${getNumberFormat(oldProduct.price)}",
                      isPrice: true),
                  const Gap(10),
                ],
              ),
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
