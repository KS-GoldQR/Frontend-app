import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/features/orders/widget/check_order_custom_cards.dart';
import 'package:grit_qr_scanner/provider/order_provider.dart';
import 'package:provider/provider.dart';

import '../../../utils/global_variables.dart';
import '../../../utils/widgets/custom_button.dart';
import 'customer_details_screen.dart';

class CheckOrderScreen extends StatelessWidget {
  const CheckOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.orderDetails),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.orderedItems,
                style: const TextStyle(
                    fontSize: 20,
                    color: blueColor,
                    fontWeight: FontWeight.bold),
              ),
              buildCheckOrderedItems(context),
              const Gap(20),
              if (orderProvider.oldJweleries.isNotEmpty) ...[
                Text(
                  AppLocalizations.of(context)!.oldJewelryItem,
                  style: const TextStyle(
                      fontSize: 20,
                      color: blueColor,
                      fontWeight: FontWeight.bold),
                ),
                buildCheckOldJwelleryItems(context),
                const Gap(20),
              ],
              if (orderProvider.orderedItems.isNotEmpty)
                CustomButton(
                  onPressed: () async {
                    Navigator.pushNamed(
                        context, CustomerDetailsScreen.routeName);
                  },
                  text: AppLocalizations.of(context)!.fillCustomerDetails,
                  textColor: Colors.white,
                  backgroundColor: blueColor,
                )
            ],
          ),
        ),
      ),
    );
    }
}
