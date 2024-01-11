import 'package:flutter/material.dart';

import '../../../models/product_model.dart';
import '../../../utils/widgets/loader.dart';
import '../services/product_service.dart';

class SoldItemsScreen extends StatefulWidget {
  static const String routeName = '/sold-items-screen';
  const SoldItemsScreen({super.key});

  @override
  State<SoldItemsScreen> createState() => _ViewSoldItemsState();
}

class _ViewSoldItemsState extends State<SoldItemsScreen> {
  List<Product>? products;
  final ProductService productService = ProductService();

  Future<void> viewSoldItems() async {
    products = await productService.viewSoldItems(context);
    setState(() {});
  }

  @override
  void initState() {
    viewSoldItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sold Items"),
      ),
      body: products == null
          ? const Loader()
          : products!.isEmpty
              ? const Center(
                  child: Text("No products are sold"),
                )
              : ListView.builder(
                  itemCount: products!.length,
                  itemBuilder: (context, index) {
                    debugPrint(products![index].id);
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(products![index].name!),
                    );
                  },
                ),
    );
  }
}
