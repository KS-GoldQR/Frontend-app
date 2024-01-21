import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/features/products/widgets/product_detail_card.dart';
import 'package:grit_qr_scanner/models/product_model.dart';
import 'package:grit_qr_scanner/utils/utils.dart';

import '../../../utils/global_variables.dart';
import '../../../utils/widgets/custom_button.dart';

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
                    label: 'Product Name: ', value: widget.product.name!),
                ProductDetail(
                    label: 'Type: ', value: widget.product.productType!),
                ProductDetail(
                    label: 'Weight: ', value: "${widget.product.weight!} gm"),
                ProductDetail(label: 'Stone: ', value: widget.product.stone!),
                ProductDetail(
                    label: 'Stone Price: ',
                    value: widget.product.stone_price.toString()),
                ProductDetail(
                    label: 'Jyala: ', value: widget.product.jyala!.toString()),
                ProductDetail(
                    label: 'Jarti: ', value: widget.product.jarti!.toString()),
                // TODO(dhiraj): dynamic rate/price for each sold product after change in api
                ProductDetail(
                  label: 'Price: ',
                  value:
                      "₹${getTotalPrice(weight: widget.product.weight!, rate: widget.product.rate!, jyalaPercent: widget.product.jyala!, jartiPercent: widget.product.jarti!, stonePrice: widget.product.stone_price!)}",
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "Owned By",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: blueColor),
                    ),
                    Text(
                      widget.product.owned_by.toString(),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
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
