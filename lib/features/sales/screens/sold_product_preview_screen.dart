import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/features/orders/screens/old_jwellery_screen.dart';
import 'package:grit_qr_scanner/features/reusable%20components/final_preview_screen.dart';
import 'package:grit_qr_scanner/features/sales/models/sold_product_model.dart';
import 'package:grit_qr_scanner/features/sales/widgets/customer_details_form.dart';
import 'package:grit_qr_scanner/provider/sales_provider.dart';
import 'package:grit_qr_scanner/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../utils/global_variables.dart';
import '../../../utils/widgets/custom_button.dart';
import '../../home/screens/qr_scanner_screen.dart';
import '../../products/screens/view_inventory_screen.dart';
import '../widgets/custom_cards.dart';

class SoldProductPreviewScreen extends StatefulWidget {
  static const String routeName = "/sold-product-preview-screen";
  const SoldProductPreviewScreen({super.key});

  @override
  State<SoldProductPreviewScreen> createState() =>
      _SoldProductPreviewScreenState();
}

class _SoldProductPreviewScreenState extends State<SoldProductPreviewScreen> {
  Future<void> _showChoiceDialogForAdd(BuildContext context) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.rightSlide,
      title: AppLocalizations.of(context)!.sellAnother,
      desc: AppLocalizations.of(context)!.howDoYouWantToSell,
      btnOkText: AppLocalizations.of(context)!.inventory,
      btnCancelText: AppLocalizations.of(context)!.scanQR,
      btnOkColor: blueColor,
      btnCancelColor: blueColor,
      btnCancelOnPress: () {
        // Navigator.popUntil(
        //     context, ModalRoute.withName(QRScannerScreen.routeName));
        // Navigator.of(context).pop();

        Navigator.of(context).pushNamed(QRScannerScreen.routeName);
      },
      btnOkOnPress: () {
        // navigatorKey.currentState!.pushNamedAndRemoveUntil(
        //     ViewInventoryScreen.routeName,
        //     ModalRoute.withName('/view-inventory-screen'));

        // Navigator.popUntil(
        //     context, ModalRoute.withName(ViewInventoryScreen.routeName));
        Navigator.of(context).pushNamed(ViewInventoryScreen.routeName);
      },
    ).show();
  }

  void _showChoiceDialogForProceed(SalesProvider sales) {
    Future.delayed(Duration.zero, () {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.question,
        animType: AnimType.rightSlide,
        title: AppLocalizations.of(context)!.oldJewellery,
        desc: AppLocalizations.of(context)!.anyOldJwelleryDeposited,
        btnOkText: AppLocalizations.of(context)!.yes,
        btnCancelText: AppLocalizations.of(context)!.no,
        btnOkColor: blueColor,
        btnCancelColor: blueColor,
        btnCancelOnPress: () {
          debugPrint(sales.oldProducts.length.toString());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => sales.oldProducts.isEmpty
                  ? const CustomerDetailsForm()
                  : const FinalPreviewScreen(isSales: true),
            ),
          );
        },
        btnOkOnPress: () {
          navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) => const OldJwelleryScreen(isSales: true),
            ),
          );
        },
      ).show();
    });
  }

  void _onWillPop(BuildContext context, SalesProvider salesProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.clearSales),
          content: Text(AppLocalizations.of(context)!.allProductsWillBeCleared),
          actions: [
            TextButton(
              onPressed: () {
                if (salesProvider.products.isNotEmpty) {
                  salesProvider.products
                      .removeAt(salesProvider.products.length - 1);
                }
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.no),
            ),
            TextButton(
              onPressed: () {
                salesProvider.resetSales();
                showSnackBar(
                    title: AppLocalizations.of(context)!.salesCleared,
                    message:
                        AppLocalizations.of(context)!.allProductsWillBeCleared,
                    contentType: ContentType.warning);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.yes),
            ),
          ],
        );
      },
    );
  }

  double getTotalSellPrice(List<SoldProduct> products) {
    double result = 0.0;
    for (var product in products) {
      result += product.amount;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final salesProvider = Provider.of<SalesProvider>(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _onWillPop(context, salesProvider);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.salesDetails),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(AppLocalizations.of(context)!.yourSalesProductList),
              const Gap(10),
              buildSalesItemsList(context),
              const Gap(20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${AppLocalizations.of(context)!.totalPrice}: ",
                      style: const TextStyle(
                          color: greyColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Text(
                      "रु${getNumberFormat(getTotalSellPrice(salesProvider.products))}",
                      style: const TextStyle(
                        fontSize: 20,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20),
              CustomButton(
                  onPressed: () {
                    _showChoiceDialogForAdd(context);
                  },
                  text: AppLocalizations.of(context)!.addOtherItem,
                  backgroundColor: blueColor,
                  textColor: Colors.white),
              const Gap(20),
              if (salesProvider.products.isNotEmpty)
                CustomButton(
                    onPressed: () {
                      debugPrint("inside function");
                      debugPrint(salesProvider.oldProducts.length.toString());
                      _showChoiceDialogForProceed(salesProvider);
                    },
                    text: AppLocalizations.of(context)!.proceed,
                    backgroundColor: blueColor,
                    textColor: Colors.white),
              const Gap(20),
            ],
          ),
        )),
      ),
    );
  }
}
