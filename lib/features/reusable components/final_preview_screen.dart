import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import '../orders/models/ordered_items_model.dart';
import '../sales/models/sold_product_model.dart';
import '../../utils/utils.dart';
import '../../utils/widgets/build_row_info.dart';
import 'package:provider/provider.dart';

import '../../provider/order_provider.dart';
import '../../provider/sales_provider.dart';
import '../../utils/global_variables.dart';
import '../../utils/widgets/custom_button.dart';
import '../orders/models/old_jwellery_model.dart';
import '../orders/screens/customer_details_screen.dart';
import '../orders/widget/check_order_custom_cards.dart';
import '../sales/widgets/check_sales_custom_card.dart';
import '../sales/widgets/customer_details_form.dart';

class FinalPreviewScreen extends StatelessWidget {
  static const String routeName = "/final-preview-screen";
  final bool isSales;
  const FinalPreviewScreen({super.key, required this.isSales});

  double totalProductAmount(List<SoldProduct> products, bool isRaw) {
    double result = 0.0;
    for (int i = 0; i < products.length; i++) {
      if (isRaw) {
        result += (products[i].weight * goldRates[products[i].type]!);
      } else {
        result += products[i].amount;
      }
    }
    return result;
  }

  double totalOrderedProductAmount(List<OrderedItems> products, bool isRaw) {
    double result = 0.0;
    for (int i = 0; i < products.length; i++) {
      if (isRaw) {
        result += (products[i].wt * goldRates[products[i].type]!);
      } else {
        result += products[i].totalPrice;
      }
    }
    return result;
  }

  double totalOldProductAmount(List<OldJwellery> oldProducts) {
    double result = 0.0;
    for (int i = 0; i < oldProducts.length; i++) {
      result += oldProducts[i].price;
    }
    return result;
  }

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
              if (isSales) ...[
                buildInfoRow(
                    "${AppLocalizations.of(context)!.total} ${AppLocalizations.of(context)!.actualPrice}",
                    "रु ${getNumberFormat(totalProductAmount(salesProvider.products, true))}",
                    isPrice: true),
                const Gap(5),
                buildInfoRow(AppLocalizations.of(context)!.soldItemPrice,
                    "रु ${getNumberFormat(totalProductAmount(salesProvider.products, false))}",
                    isPrice: true),
                const Gap(5),
                buildInfoRow(
                    AppLocalizations.of(context)!.oldJwelleryTotalPrice,
                    "रु ${getNumberFormat(totalOldProductAmount(salesProvider.oldProducts))}",
                    isPrice: true),
                const Gap(5),
                buildInfoRow(AppLocalizations.of(context)!.differencePrice,
                    "रु ${getNumberFormat(totalProductAmount(salesProvider.products, false) - totalOldProductAmount(salesProvider.oldProducts))}",
                    isPrice: true),
                const Gap(10),
              ],
              if (!isSales) ...[
                buildInfoRow(
                    "${AppLocalizations.of(context)!.total} ${AppLocalizations.of(context)!.actualPrice}",
                    "रु ${getNumberFormat(totalOrderedProductAmount(orderProvider.orderedItems, true))}",
                    isPrice: true),
                const Gap(5),
                buildInfoRow(
                    AppLocalizations.of(context)!.orderedItemsTotalPrice,
                    "रु ${getNumberFormat(totalOrderedProductAmount(orderProvider.orderedItems, false))}",
                    isPrice: true),
                const Gap(5),
                buildInfoRow(
                    AppLocalizations.of(context)!.oldJwelleryTotalPrice,
                    "रु ${totalOldProductAmount(orderProvider.oldJwelleries)}",
                    isPrice: true),
                const Gap(5),
                buildInfoRow(AppLocalizations.of(context)!.differencePrice,
                    "रु ${getNumberFormat(totalOrderedProductAmount(orderProvider.orderedItems, false) - totalOldProductAmount(orderProvider.oldJwelleries))}",
                    isPrice: true),
                const Gap(10),
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
