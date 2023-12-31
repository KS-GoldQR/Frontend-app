import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/features/products/services/product_service.dart';
import 'package:grit_qr_scanner/utils/widgets/custom_button.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:image_picker/image_picker.dart';

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
  final ProductService _productService = ProductService();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _stoneController = TextEditingController();
  final TextEditingController _stonePriceController = TextEditingController();
  final TextEditingController _jyalaController = TextEditingController();
  final TextEditingController _jartiController = TextEditingController();

  List<String> types = ['Chapawala', 'Tejabi', 'Chapi'];
  String selectedType = 'Chapawala';

  List<String> weight = ['Tola', 'Gram', 'Laal'];
  String selectedWeight = 'Tola';
  File? images;
  int currentIndex = 0;

  Future<void> _pickImage(ImageSource source) async {
    images = await pickFile(context, source);
    setState(() {});
  }

  void addProduct(File image) async {
    debugPrint("hit");
    _productService.addProduct(context, image);
  }

  Future<void> _showChoiceDialog() async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.rightSlide,
      title: 'Upload Image',
      desc: 'choose to upload image of product',
      btnOkText: 'Gallery',
      btnCancelText: 'Camera',
      btnOkColor: blueColor,
      btnCancelColor: blueColor,
      btnCancelOnPress: () {
        _pickImage(ImageSource.camera);
      },
      btnOkOnPress: () {
        _pickImage(ImageSource.gallery);
      },
    ).show();
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
                      const Gap(10),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: null,
                        decoration: const InputDecoration.collapsed(
                          hintText: "Enter the description for the product",
                        ),
                      ),
                      const Gap(10),
                      GestureDetector(
                        onTap: _showChoiceDialog,
                        child: images == null
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
                            : Image.file(
                                images!,
                                fit: BoxFit.contain,
                                height: size.height * 0.2,
                                width: double.infinity,
                              ),
                      ),
                      const Gap(10),
                      Text(
                        "Name of Product",
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
                        "Type",
                        style: customTextDecoration(),
                      ),
                      const Gap(5),
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
                      const Gap(10),
                      Text(
                        "Weight",
                        style: customTextDecoration(),
                      ),
                      const Gap(5),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _weightController,
                              decoration: customTextfieldDecoration(),
                            ),
                          ),
                          const Gap(10),
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
                      const Gap(10),
                      Text(
                        "Stone",
                        style: customTextDecoration(),
                      ),
                      const Gap(5),
                      TextFormField(
                        controller: _stoneController,
                        cursorColor: blueColor,
                        decoration: customTextfieldDecoration(),
                      ),
                      const Gap(10),
                      Text(
                        "Stone Price",
                        style: customTextDecoration(),
                      ),
                      const Gap(5),
                      TextFormField(
                        controller: _stonePriceController,
                        cursorColor: blueColor,
                        decoration: customTextfieldDecoration(),
                      ),
                      const Gap(10),
                      Text(
                        "Jyala",
                        style: customTextDecoration(),
                      ),
                      const Gap(5),
                      TextFormField(
                        controller: _jyalaController,
                        cursorColor: blueColor,
                        decoration: customTextfieldDecoration(),
                      ),
                      const Gap(10),
                      Text(
                        "Jarti",
                        style: customTextDecoration(),
                      ),
                      const Gap(5),
                      TextFormField(
                        controller: _jartiController,
                        cursorColor: blueColor,
                        decoration: customTextfieldDecoration(),
                      ),
                      const Gap(10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: CustomButton(
          onPressed: () => addProduct(images!),
          text: "Submit",
          textColor: Colors.white,
          backgroundColor: blueColor,
        ),
      ),
    );
  }
}
