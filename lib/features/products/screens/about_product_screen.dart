// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:grit_qr_scanner/features/products/services/product_service.dart';
import 'package:grit_qr_scanner/models/product_model.dart';

import '../../../utils/custom_appbar.dart';
import '../../../utils/custom_button.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/product_detail_card.dart';

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

  final String productDescription =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
      "Sed do eiusmod tempor incididunt ut";

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
      appBar: PreferredSize(
        preferredSize: Size(
          double.infinity,
          MediaQuery.sizeOf(context).height * 0.06,
        ),
        child: CustomAppbar(
          menuIcon: menuIcon,
          avatar: avatar,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              const Gap(10), // Add some spacing
              SingleChildScrollView(
                child: Text(
                  productDescription,
                  textAlign:
                      TextAlign.justify, // Your full product description here
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const Gap(10), // Add some spacing
              Container(
                height: 200,
                color: Colors.grey,
              ),
              const Gap(10),
              const ProductDetail(label: 'Product Name: ', value: "name"),
              const ProductDetail(label: 'Type: ', value: "address"),
              const ProductDetail(label: 'Weight: ', value: "name"),
              const ProductDetail(label: 'Stone: ', value: "address"),
              const ProductDetail(label: 'Stone Price: ', value: "address"),
              const ProductDetail(label: 'Jyala: ', value: "name"),
              const ProductDetail(label: 'Jarti: ', value: "address"),
              const ProductDetail(label: 'Price: ', value: "address"),
              const Gap(20),
              CustomButton(
                onPressed: () {},
                text: "Sell Item",
                backgroundColor: blueColor,
                iconColor: Colors.white,
                textColor: Colors.white,
                iconPath: 'assets/icons/material-symbols_sell.svg',
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () {},
                      text: "Edit Item",
                      iconColor: blueColor,
                      textColor: blueColor,
                      iconPath: 'assets/icons/bx_edit.svg',
                      fontSize: 15,
                    ),
                  ),
                  const Gap(5),
                  Expanded(
                    child: CustomButton(
                      onPressed: () {},
                      text: "Delete Item",
                      iconColor: blueColor,
                      textColor: blueColor,
                      fontSize: 15,
                      iconPath: 'assets/icons/ic_round-delete.svg',
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

