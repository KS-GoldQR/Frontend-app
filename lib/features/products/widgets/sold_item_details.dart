import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/features/products/widgets/product_detail_card.dart';
import 'package:grit_qr_scanner/models/product_model.dart';
import 'package:grit_qr_scanner/utils/utils.dart';
import 'package:intl/intl.dart';

import '../../../utils/global_variables.dart';
import '../../../utils/widgets/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SoldItemDetails extends StatefulWidget {
  final Product product;
  const SoldItemDetails({super.key, required this.product});

  @override
  State<SoldItemDetails> createState() => _SoldItemDetailsState();
}

class _SoldItemDetailsState extends State<SoldItemDetails> {
  int currentIndex = 0;

  final String productDescription = "description not added yet!";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.product.name!,
                          style: const TextStyle(
                            color: blueColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    CustomButton(
                      onPressed: () {},
                      text: "Sold",
                      backgroundColor: Colors.green,
                      iconColor: Colors.white,
                      textColor: Colors.white,
                    ),
                  ],
                ),
                const Gap(10), // Add some spacing
                Text(
                  productDescription,
                  textAlign:
                      TextAlign.justify, // Your full product description here
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const Gap(10), // Add some spacing
                SizedBox(
                  height: 200,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: widget.product.image!,
                        fit: BoxFit.contain,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) =>
                            const Text("error getting image!"),
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                ProductDetail(
                    label: '${AppLocalizations.of(context)!.name}: ',
                    value: widget.product.name!),
                ProductDetail(
                    label: '${AppLocalizations.of(context)!.type}: ',
                    value: widget.product.productType!),
                ProductDetail(
                    label: '${AppLocalizations.of(context)!.weight}: ',
                    value:
                        "${getWeightByType(widget.product.weight!, "Gram")} ${AppLocalizations.of(context)!.gram}"),
                ProductDetail(
                    label: '${AppLocalizations.of(context)!.weight}: ',
                    value:
                        "${getWeightByType(widget.product.weight!, "Laal")} ${AppLocalizations.of(context)!.laal}"),
                ProductDetail(
                    label: '${AppLocalizations.of(context)!.weight}: ',
                    value:
                        "${getWeightByType(widget.product.weight!, "Tola")} ${AppLocalizations.of(context)!.tola}"),
                ProductDetail(
                    label: '${AppLocalizations.of(context)!.stone}: ',
                    value: widget.product.stone!),
                ProductDetail(
                    label: '${AppLocalizations.of(context)!.stonePrice}: ',
                    value:
                        "रु${NumberFormat('#,##,###.00').format(widget.product.stone_price)}"),
                ProductDetail(
                    label: '${AppLocalizations.of(context)!.jyala}: ',
                    value: widget.product.jyala!.toString()),
                ProductDetail(
                    label: '${AppLocalizations.of(context)!.jarti}: ',
                    value: widget.product.jarti!.toString()),
                ProductDetail(
                  label: '${AppLocalizations.of(context)!.price}: ',
                  value:
                      "रु${NumberFormat('#,##,###.00').format(widget.product.price)}",
                ),
                const Gap(10),

                const Gap(10),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
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
