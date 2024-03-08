import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../provider/order_provider.dart';
import '../../provider/sales_provider.dart';
import '../../utils/global_variables.dart';
import '../../utils/widgets/custom_button.dart';
import '../sales/widgets/check_sales_custom_card.dart';
import '../sales/widgets/customer_details_form.dart';
import '../orders/widget/check_order_custom_cards.dart';
import '../orders/screens/customer_details_screen.dart';

class FinalPreviewScreen extends StatelessWidget {
  static const String routeName = "/final-preview-screen";
  final bool isSales;
  const FinalPreviewScreen({super.key, required this.isSales});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: true);
    final salesProvider = Provider.of<SalesProvider>(context, listen: false);

    debugPrint(isSales.toString());
    debugPrint(orderProvider.orderedItems.length.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(isSales
            ? AppLocalizations.of(context)!.salesDetails
            : AppLocalizations.of(context)!.orderDetails),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isSales
                    ? AppLocalizations.of(context)!.soldItems
                    : AppLocalizations.of(context)!.orderedItems,
                style: const TextStyle(
                    fontSize: 20,
                    color: blueColor,
                    fontWeight: FontWeight.bold),
              ),
              isSales
                  ? buildCheckSoldProduct(context)
                  : buildCheckOrderedItems(context),
              const Gap(20),
              if (isSales
                  ? salesProvider.oldProducts.isNotEmpty
                  : orderProvider.oldJwelleries.isNotEmpty) ...[
                Text(
                  AppLocalizations.of(context)!.oldJewelleryItem,
                  style: const TextStyle(
                      fontSize: 20,
                      color: blueColor,
                      fontWeight: FontWeight.bold),
                ),
                isSales
                    ? buildCheckSoldOldProduct(context)
                    : buildCheckOldJwelleryItems(context),
                const Gap(20),
              ],
              if (isSales
                  ? salesProvider.products.isNotEmpty
                  : orderProvider.orderedItems.isNotEmpty)
                CustomButton(
                  onPressed: () async {
                    isSales
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CustomerDetailsForm(),
                            ),
                          )
                        : Navigator.pushNamed(
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
