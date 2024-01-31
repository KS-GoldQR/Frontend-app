import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/models/sales_model.dart';
import 'package:grit_qr_scanner/utils/widgets/build_row_info.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class SoldStatusCard extends StatelessWidget {
  final Map<SalesModel, bool> status;
  const SoldStatusCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    debugPrint(status.length.toString());
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.yourSalesProductList,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Gap(20),
                for (var entry in status.entries)
                  SalesItemTile(entry.key, entry.value),
                const Gap(10),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.close),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SalesItemTile extends StatelessWidget {
  final SalesModel saleItem;
  final bool isSold;

  const SalesItemTile(this.saleItem, this.isSold, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildInfoRow(
              saleItem.product.name!,
              "${AppLocalizations.of(context)!.type}: ${saleItem.product.productType == "Chhapawal" ? AppLocalizations.of(context)!.chhapawal : saleItem.product.productType == "Tejabi" ? AppLocalizations.of(context)!.tejabi : AppLocalizations.of(context)!.asalChandi} \n ${AppLocalizations.of(context)!.weight}: ${saleItem.weight} ${AppLocalizations.of(context)!.gram} \n ${AppLocalizations.of(context)!.jyala}: ${saleItem.jyalaPercentage}% \n ${AppLocalizations.of(context)!.jarti}: ${saleItem.jartiPercentage}% \n ${AppLocalizations.of(context)!.price}: ${NumberFormat('#,##,###.00').format(saleItem.price)} \n",
            ),
            const Gap(10),
            Text(
              isSold ? "Status: Sold" : "Status: Not Sold",
              style: TextStyle(
                color: isSold ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
