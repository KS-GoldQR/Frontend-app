import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/utils/custom_appbar.dart';

import '../../../models/product_model.dart';
import '../../../utils/custom_button.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/product_detail_card.dart';
import '../../../utils/utils.dart';
import '../services/product_service.dart';

class SellProductScreen extends StatefulWidget {
  static const String routeName = '/sell-product-screen';
  const SellProductScreen({super.key});

  @override
  State<SellProductScreen> createState() => _SellProductScreenState();
}

class _SellProductScreenState extends State<SellProductScreen> {
  final String menuIcon = 'assets/icons/solar_hamburger-menu-broken.svg';
  final String avatar = 'assets/images/avtar.svg';
  final _sellProductFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _priceSoldController = TextEditingController();
  final ProductService productService = ProductService();
  Product? product;
  int currentIndex = 0;

  final String productDescription =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
      "Sed do eiusmod tempor incididunt ut";

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _priceSoldController.dispose();
    super.dispose();
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
                "Sell Product",
                style: TextStyle(
                  color: blueColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Gap(10),
              SingleChildScrollView(
                child: Text(
                  productDescription,
                  textAlign:
                      TextAlign.justify, 
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const Gap(10), 
              Container(
                height: 200,
                color: Colors.grey,
              ),
              const Gap(10),
              const ProductDetail(label: 'Product Name: ', value: "name"),
              const ProductDetail(label: 'Type: ', value: "address"),
              const ProductDetail(label: 'Weight: ', value: "name"),
              const ProductDetail(label: 'Stone: ', value: "address"),
              const ProductDetail(label: 'Price: ', value: "address"),
              const Gap(20),
              Form(
                key: _sellProductFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(10),
                    Text(
                      "Customer Name:",
                      style: customTextDecoration(),
                    ),
                    const Gap(5),
                    TextFormField(
                      controller: _nameController,
                      cursorColor: blueColor,
                      decoration: customTextfieldDecoration(),
                    ),
                    const Gap(10),
                    Text(
                      "Customer Phone Number:",
                      style: customTextDecoration(),
                    ),
                    const Gap(5),
                    TextFormField(
                      controller: _phoneNumberController,
                      cursorColor: blueColor,
                      decoration: customTextfieldDecoration(),
                    ),
                    const Gap(10),
                    Text(
                      "Customer Address:",
                      style: customTextDecoration(),
                    ),
                    const Gap(5),
                    TextFormField(
                      controller: _addressController,
                      cursorColor: blueColor,
                      decoration: customTextfieldDecoration(),
                    ),
                    const Gap(10),
                    Text(
                      "Price Sold:",
                      style: customTextDecoration(),
                    ),
                    const Gap(5),
                    TextFormField(
                      controller: _priceSoldController,
                      cursorColor: blueColor,
                      decoration: customTextfieldDecoration(),
                    ),
                  ],
                ),
              ),
              const Gap(15),
              CustomButton(
                onPressed: () {},
                text: "Confirm",
                backgroundColor: blueColor,
                textColor: Colors.white,
              ),
              const Gap(15),
            ],
          ),
        ),
      ),
    );
  }
}
