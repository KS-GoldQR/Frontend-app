import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../../models/order_model.dart';
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
              NumberFormat('#,##,###.00').format(totalOrderedPrice)),
          buildInfoRow(AppLocalizations.of(context)!.oldJewelryTotalPrice,
              NumberFormat('#,##,###.00').format(totalOldJwelleryPrice)),
          buildInfoRow(
              AppLocalizations.of(context)!.differencePrice,
              NumberFormat('#,##,###.00')
                  .format(totalOrderedPrice - totalOldJwelleryPrice)),
          buildInfoRow(AppLocalizations.of(context)!.advancePayment,
              NumberFormat('#,##,###.00').format(order.advanced_payment)),
          buildInfoRow(AppLocalizations.of(context)!.remaining,
              NumberFormat('#,##,###.00').format(order.remaining_payment)),
          buildInfoRow(AppLocalizations.of(context)!.deadline,
              DateFormat.yMMMd().format(order.expected_deadline)),
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
            children: [
              buildInfoRow(
                orderedItem.itemName,
                "${AppLocalizations.of(context)!.type}: ${orderedItem.type == "Chhapawal" ? AppLocalizations.of(context)!.chhapawal : orderedItem.type == "Tejabi" ? AppLocalizations.of(context)!.tejabi : AppLocalizations.of(context)!.asalChandi} \n ${AppLocalizations.of(context)!.weight}: ${orderedItem.wt} ${AppLocalizations.of(context)!.gram} \n ${AppLocalizations.of(context)!.price}: ${NumberFormat('#,##,###.00').format(orderedItem.totalPrice)}",
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
          final oldJwellery = order.old_jwellery![index];

          return Column(
            children: [
              buildInfoRow(
                  oldJwellery.itemName,
                  "${AppLocalizations.of(context)!.type}: ${oldJwellery.type == "Chhapawal" ? AppLocalizations.of(context)!.chhapawal : oldJwellery.type == "Tejabi" ? AppLocalizations.of(context)!.tejabi : AppLocalizations.of(context)!.asalChandi} \n ${AppLocalizations.of(context)!.weight}: ${oldJwellery.wt} ${AppLocalizations.of(context)!.gram} \n ${AppLocalizations.of(context)!.price}: ${NumberFormat('#,##,###.00').format(oldJwellery.price)} \n ${AppLocalizations.of(context)!.rate}: ${NumberFormat('#,##,###.00').format(oldJwellery.rate)}"),
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
