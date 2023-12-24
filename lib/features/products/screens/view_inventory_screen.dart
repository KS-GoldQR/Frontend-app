import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grit_qr_scanner/features/products/services/product_service.dart';
import 'package:grit_qr_scanner/models/product_model.dart';
import 'package:grit_qr_scanner/utils/widgets/loader.dart';

import '../../../utils/global_variables.dart';

class ViewInventoryScreeen extends StatefulWidget {
  static const String routeName = '/view-inventory-screen';
  const ViewInventoryScreeen({super.key});

  @override
  State<ViewInventoryScreeen> createState() => _ViewInventoryScreeenState();
}

class _ViewInventoryScreeenState extends State<ViewInventoryScreeen> {
  final String menuIcon = 'assets/icons/solar_hamburger-menu-broken.svg';
  final String avatar = 'assets/images/avtar.svg';
  List<Product>? products;
  final ProductService productService = ProductService();
  List<String> types = ['Chapawala', 'Tejabi', 'Chapi'];
  String? selectedType;
  Map<String, List<Product>> groupedProducts = {};

  Future<void> getInventory() async {
    products = await productService.getInventory(context);
    setState(() {});
    getGroupedProduct();
  }

  void getGroupedProduct() {
    for (var product in products!) {
      if (!groupedProducts.containsKey(product.type)) {
        groupedProducts[product.type] = [];
      }
      groupedProducts[product.type]!.add(product);
    }
  }

  @override
  void initState() {
    getInventory();
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
                "Product Inventory",
                style: TextStyle(
                  color: blueColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Text("Collection of Products"),
              const SizedBox(height: 15),
              Center(
                child: Column(
                  children: [
                    const Text(
                      "Select Category",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF282828),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButtonFormField<String>(
                        decoration: customTextfieldDecoration(),
                        isExpanded: true,
                        isDense: true,
                        hint: const Text(
                          "Category Name",
                          style: TextStyle(
                            color: Color(0xFFA4A1A1),
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        value: selectedType,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 24,
                        iconDisabledColor: const Color(0xFFC3C3C3),
                        iconEnabledColor: const Color(0xFFC3C3C3),
                        elevation: 16,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedType = newValue!;
                          });
                        },
                        items:
                            types.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              products == null
                  ? const Center(child: Loader())
                  : products!.isEmpty
                      ? const Center(
                          child: Text("No Product in Inventory"),
                        )
                      : Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: groupedProducts.entries.map((entry) {
                              String category = entry.key;
                              List<Product> categoryProducts = entry.value;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    category,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    // physics:
                                    //     const NeverScrollableScrollPhysics(),
                                    itemCount: categoryProducts.length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 8.0,
                                    ),
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: const EdgeInsets.all(8.0),
                                        child:
                                            Text(categoryProducts[index].image),
                                        // TODO(dhiraj): Make cards as in fighma
                                      );
                                    },
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
            ],
          ),
        ));
  }

  InputDecoration customTextfieldDecoration() {
    return const InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFFC3C3C3),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFFC3C3C3),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xFFC3C3C3),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    );
  }
}
