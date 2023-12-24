import 'dart:io';

import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';

import '../../../utils/utils.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product-screen';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final String menuIcon = 'assets/icons/solar_hamburger-menu-broken.svg';
  final String avatar = 'assets/images/avtar.svg';
  final addProductFormKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _stoneController = TextEditingController();
  final TextEditingController _stonePriceController = TextEditingController();
  final TextEditingController _jyalaController = TextEditingController();
  final TextEditingController _jartiController = TextEditingController();

  List<String> types = ['Chapawala', 'Tejabi', 'Chapi'];
  String selectedType = 'Chapawala';

  List<String> weight = ['Tola', 'Gram'];
  String selectedWeight = 'Tola';
  List<File> images = [];
  int currentIndex = 0;

  void selectFiles() async {
    var result = await pickFiles(context);
    setState(() {
      images = result;
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _nameController.dispose();
    _weightController.dispose();
    _stoneController.dispose();
    _stonePriceController.dispose();
    _jyalaController.dispose();
    _jartiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
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
              "Add Product",
              style: TextStyle(
                color: blueColor,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Expanded(
              child: Form(
                key: addProductFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: null,
                        decoration: const InputDecoration.collapsed(
                          hintText: "Enter the description for the product",
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: selectFiles,
                        child: images.isEmpty
                            ? DottedBorder(
                                strokeWidth: 1,
                                borderType: BorderType.RRect,
                                borderPadding: const EdgeInsets.all(5),
                                dashPattern: const [10, 4],
                                radius: const Radius.circular(15),
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  height: size.height * 0.2,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.folder_open_outlined,
                                        size: 35,
                                        color: Colors.black,
                                      ),
                                      Text(
                                        'Select Product Images',
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CarouselSlider(
                                    items: images.map((e) {
                                      return Builder(
                                        builder: (context) => Image.file(
                                          e,
                                          fit: BoxFit.cover,
                                          height: 200,
                                        ),
                                      );
                                    }).toList(),
                                    options: CarouselOptions(
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          currentIndex = index;
                                        });
                                      },
                                      viewportFraction: 1,
                                      height: 200,
                                      autoPlay: true,
                                      autoPlayCurve: Curves.decelerate,
                                    ),
                                  ),
                                  CarouselIndicator(
                                    count: images.length,
                                    index: currentIndex,
                                    color: Colors.grey,
                                    activeColor: blueColor,
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Name of Product",
                        style: customTextDecoration(),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _nameController,
                        cursorColor: blueColor,
                        decoration: customTextfieldDecoration(),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Type",
                        style: customTextDecoration(),
                      ),
                      const SizedBox(height: 5),
                      DropdownButtonFormField<String>(
                        value: selectedType,
                        iconEnabledColor: const Color(0xFFC3C3C3),
                        iconDisabledColor: const Color(0xFFC3C3C3),
                        iconSize: 25,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                        items: types.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedType = value!;
                          });
                        },
                        decoration: customTextfieldDecoration(),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Weight",
                        style: customTextDecoration(),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _weightController,
                              decoration: customTextfieldDecoration(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              value: selectedWeight,
                              iconEnabledColor: const Color(0xFFC3C3C3),
                              iconDisabledColor: const Color(0xFFC3C3C3),
                              iconSize: 25,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                              ),
                              items: weight.map((category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedWeight = value!;
                                });
                              },
                              decoration: customTextfieldDecoration(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Stone",
                        style: customTextDecoration(),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _stoneController,
                        cursorColor: blueColor,
                        decoration: customTextfieldDecoration(),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Stone Price",
                        style: customTextDecoration(),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _stonePriceController,
                        cursorColor: blueColor,
                        decoration: customTextfieldDecoration(),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Jyala",
                        style: customTextDecoration(),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _jyalaController,
                        cursorColor: blueColor,
                        decoration: customTextfieldDecoration(),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Jarti",
                        style: customTextDecoration(),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _jartiController,
                        cursorColor: blueColor,
                        decoration: customTextfieldDecoration(),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: size.height * 0.1,
        width: size.width * 0.9,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 30),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: blueColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            "Submit",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  TextStyle customTextDecoration() {
    return const TextStyle(
      color: Color(0xFF282828),
      fontSize: 15,
      fontWeight: FontWeight.w400,
      fontFamily: 'Inter',
    );
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
