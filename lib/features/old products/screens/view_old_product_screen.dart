import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../models/product_model.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/utils.dart';
import '../../products/widgets/product_detail_card.dart';

class ViewOldProductScreen extends StatefulWidget {
  final Product product;
  const ViewOldProductScreen({super.key, required this.product});

  @override
  State<ViewOldProductScreen> createState() => _ViewOldProductScreenState();
}

class _ViewOldProductScreenState extends State<ViewOldProductScreen> {
  final String productDescription = "Description not added yet!";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () async {
      await getRate(context);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.viewProduct,
          style: const TextStyle(fontSize: 20),
        ),
        centerTitle: false,
      ),
      body: goldRates.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.productInfo,
                      style: const TextStyle(
                        color: blueColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Gap(10), // Add some spacing
                    SingleChildScrollView(
                      child: Text(
                        productDescription,
                        textAlign: TextAlign
                            .justify, // Your full product description here
                        style: const TextStyle(
                          fontSize: 16,
                        ),
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
                                Text(AppLocalizations.of(context)!.errorGettingImage),
                          ),
                        ),
                      ),
                    ),
                    const Gap(10),
                    ProductDetail(
                        label: '${AppLocalizations.of(context)!.productName}: ',
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
                        label: '${AppLocalizations.of(context)!.actualPrice}: ',
                        value:
                            "रु${NumberFormat('#,##,###.00').format(widget.product.weight! * goldRates[widget.product.productType!]!)}"),
                    if (widget.product.stone != "None")
                      ProductDetail(
                          label: '${AppLocalizations.of(context)!.stone}: ',
                          value: widget.product.stone!),
                    if (widget.product.stone_price != -1)
                      ProductDetail(
                          label:
                              '${AppLocalizations.of(context)!.stonePrice}: ',
                          value:
                              "रु${NumberFormat('#,##,###.00').format(widget.product.stone_price)}"),
                    ProductDetail(
                        label: '${AppLocalizations.of(context)!.price}: ',
                        value:
                            "रु${NumberFormat('#,##,###.00').format((widget.product.weight! * goldRates[widget.product.productType!]!) + (widget.product.stone_price! != -1 ? widget.product.stone_price! : 0.0))}"),
                  ],
                ),
              ),
            ),
    );
  }
}
