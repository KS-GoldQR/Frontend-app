import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import '../../../models/order_model.dart';
import '../../../utils/custom_decorators.dart';
import '../../../utils/utils.dart';
import '../../../utils/widgets/build_row_info.dart';

Widget buildUserInfoCard(Order order, BuildContext context,
    double totalOrderedPrice, double totalOldJwelleryPrice) {
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
          buildInfoRow(AppLocalizations.of(context)!.name, order.customer_name),
          buildInfoRow(AppLocalizations.of(context)!.contactNumber,
              order.customer_phone),
          buildInfoRow(AppLocalizations.of(context)!.orderedItemsTotalPrice,
              "रु ${getNumberFormat(totalOrderedPrice)}",
              isPrice: true),
          buildInfoRow(AppLocalizations.of(context)!.oldJwelleryTotalPrice,
              "रु ${getNumberFormat(totalOldJwelleryPrice)}",
              isPrice: true),
          buildInfoRow(AppLocalizations.of(context)!.differencePrice,
              "रु ${getNumberFormat(totalOrderedPrice - totalOldJwelleryPrice)}",
              isPrice: true),
          buildInfoRow(AppLocalizations.of(context)!.advancePayment,
              "रु ${getNumberFormat(order.advanced_payment)}",
              isPrice: true),
          buildInfoRow(AppLocalizations.of(context)!.remaining,
              "रु ${getNumberFormat(order.remaining_payment)}",
              isPrice: true),
          buildInfoRow(AppLocalizations.of(context)!.deadline,
              formatDateTime(order.expected_deadline)),
        ],
      ),
    ),
  );
}

Widget buildOrderedItemsList(Order order, BuildContext context) {
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
        itemCount: order.ordered_items?.length ?? 0,
        itemBuilder: (context, index) {
          final orderedItem = order.ordered_items![index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                orderedItem.itemName,
                style: customTextDecoration().copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Column(
                children: [
                  buildInfoRow(
                      AppLocalizations.of(context)!.type,
                      orderedItem.type == "Chhapawal"
                          ? AppLocalizations.of(context)!.chhapawal
                          : orderedItem.type == "Tejabi"
                              ? AppLocalizations.of(context)!.tejabi
                              : AppLocalizations.of(context)!.asalChandi),
                  buildInfoRow(AppLocalizations.of(context)!.weight,
                      "${orderedItem.wt} ${AppLocalizations.of(context)!.gram}"),
                  buildInfoRow(AppLocalizations.of(context)!.price,
                      "रु ${getNumberFormat(orderedItem.totalPrice)}",
                      isPrice: true),
                  const Gap(10),
                ],
              ),
              if (index != order.ordered_items!.length - 1)
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

Widget buildOldJwelleryList(Order order, BuildContext context) {
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
        itemCount: order.old_jwellery?.length ?? 0,
        itemBuilder: (context, index) {
          final oldProduct = order.old_jwellery![index];

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
              if (index != order.old_jwellery!.length - 1)
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
