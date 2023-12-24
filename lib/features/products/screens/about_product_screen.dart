
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grit_qr_scanner/features/products/services/product_service.dart';
import 'package:grit_qr_scanner/models/product_model.dart';

import '../../../utils/global_variables.dart';

class AboutProduct extends StatefulWidget {
  static const String routeName = '/about-product-screen';
  final String productId;
  const AboutProduct({super.key, required this.productId});

  @override
  State<AboutProduct> createState() => _AboutProductState();
}

class _AboutProductState extends State<AboutProduct> {
  final String menuIcon = 'assets/icons/solar_hamburger-menu-broken.svg';
  final String avatar = 'assets/images/avtar.svg';
  final ProductService productService = ProductService();
  Product? product;
  int currentIndex = 0;

  Future<void> getProduct() async {
    product = await productService.viewProduct(context, widget.productId);
    setState(() {});
  }

  @override
  void initState() {
    getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: SvgPicture.asset(
            menuIcon,
            // ignore: deprecated_member_use
            color: Colors.black,
          ),
        ),
        actions: [
          CircleAvatar(
            radius: 20,
            child: SvgPicture.asset(
              avatar,
              fit: BoxFit.contain,
              height: 55,
            ),
          ),
          const SizedBox(
            width: 30,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Product Info",
              style: TextStyle(
                color: blueColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: product == null
                  ? const Center(
                      child: Text("Product Not Found!"),
                    )
                  : Text(product!.name),
            ),
          ],
        ),
      ),
    );
  }
}
