import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/features/products/services/product_service.dart';
import 'package:grit_qr_scanner/utils/widgets/custom_button.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../utils/utils.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product-screen';
  final Map<String, dynamic> args;
  const EditProductScreen({super.key, required this.args});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final String menuIcon = 'assets/icons/solar_hamburger-menu-broken.svg';
  final String avatar = 'assets/images/avtar.svg';
  final _addProductFormKey = GlobalKey<FormState>();
  final ProductService _productService = ProductService();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _stoneController = TextEditingController();
  final TextEditingController _stonePriceController = TextEditingController();
  final TextEditingController _jyalaController = TextEditingController();
  final TextEditingController _jartiController = TextEditingController();

  List<String> types = ['Chapawala', 'Tejabi', 'Asal_chaadhi', 'cgold_1tola'];
  String selectedType = 'Chapawala';

  List<String> weight = ['Tola', 'Gram', 'Laal'];
  String selectedWeight = 'Gram';
  File? images;
  int currentIndex = 0;
  bool isSubmitting = false;

  Future<void> _pickImage(ImageSource source) async {
    images = await pickFile(context, source);
    setState(() {});
  }

  void isFormValid() {
    if (_addProductFormKey.currentState!.validate()) {
      setState(() {
        isSubmitting = true;
      });
      editProduct();
      setState(() {
        isSubmitting = false;
      });
    } else {
      debugPrint("error occured in edit form page");
    }
  }

//image will be file type, sessiontoken will be dynamic
  Future<void> editProduct() async {
    await _productService.editProduct(
      context: context,
      sessionToken:
          "f992f891da40c3d251cd6fb9a5828cd84cdd363f03f7bf2571c027369afa2b8b",
      productId: widget.args['product'].id,
      image:
          "https://plus.unsplash.com/premium_photo-1678730056371-eff9c5356a48?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Z29sZCUyMG5lY2tsYWNlfGVufDB8fDB8fHww",
      name: _nameController.text.trim(),
      productType: selectedType,
      weight: getWeight(
          double.tryParse(_weightController.text.trim())!, selectedWeight),
      stone: _stoneController.text.trim(),
      // stonePrice: double.tryParse(_stonePriceController.text.trim())!,
      stonePrice: 0.0,
      jyala: double.tryParse(_jyalaController.text.trim())!,
      jarti: double.tryParse(_jartiController.text.trim())!,
    );
  }

  double getWeight(double weight, String selectedWeightType) {
    double result;

    if (selectedWeightType == "Tola") {
      result = weight * 11.664;
    } else if (selectedWeightType == "Laal") {
      result = weight * 0.1166;
    } else {
      result = weight;
    }

    return double.parse(result.toStringAsFixed(3));
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

  Future<void> _onWillPop() async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.rightSlide,
      title: 'Want to scan again?',
      desc: 'All progress will disappear',
      btnOkText: 'Yes',
      btnCancelText: 'No',
      btnOkColor: blueColor,
      btnCancelColor: blueColor,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        if (widget.args['fromAboutProduct'] == false) {
          widget.args['callback']();
        }
        Navigator.pop(context);
      },
    ).show();
  }

  @override
  void initState() {
    super.initState();
    if (widget.args['fromAboutProduct']) {
      _nameController.text = widget.args['product'].name;
      selectedType = widget.args['product'].productType;
      _weightController.text = widget.args['product'].weight.toString();
      _stoneController.text = widget.args['product'].stone;
      _stonePriceController.text =
          widget.args['product'].stone_price.toString();
      _jyalaController.text = widget.args['product'].jyala.toString();
      _jartiController.text = widget.args['product'].jarti.toString();
    }
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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => _onWillPop(),
      child: ModalProgressHUD(
        inAsyncCall: isSubmitting,
        progressIndicator: const SpinKitRotatingCircle(color: blueColor),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: SvgPicture.asset(menuIcon,
                  colorFilter:
                      const ColorFilter.mode(Colors.black, BlendMode.srcIn)),
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
                  "Add/Edit Product",
                  style: TextStyle(
                    color: blueColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(
                  child: Form(
                    key: _addProductFormKey,
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
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return "Description cannot be empty";
                            //   }
                            //   if (value.length > 500) {
                            //     return "Description length should be less than 500 characters";
                            //   }
                            //   return null;
                            // },
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "weight cannot be empty!";
                                    }

                                    if (double.tryParse(value) == null) {
                                      return "enter a valid number";
                                    }

                                    if (double.tryParse(value)! <= 0) {
                                      return "weight cannot be negative/zero";
                                    }

                                    return null;
                                  },
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
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "stone cannot be empty!";
                              }
                              return null;
                            },
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
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return "stone price cannot be empty!";
                            //   }
                            //   if (double.tryParse(value!) == null) {
                            //     return "enter a valid number";
                            //   }
                            //   if (double.tryParse(value)! <= 0) {
                            //     return "stone price cannot be negative/zero";
                            //   }
                            //   return null;
                            // },
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
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "jyala cannot be empty!";
                              }

                              if (double.tryParse(value) == null) {
                                return "enter a valid number";
                              }

                              if (double.tryParse(value)! < 0) {
                                return "jyala cannot be negative/zero";
                              }

                              return null;
                            },
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
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "jarti cannot be empty!";
                              }

                              if (double.tryParse(value) == null) {
                                return "enter a valid number";
                              }

                              if (double.tryParse(value)! < 0) {
                                return "jarti cannot be negative/zero";
                              }

                              return null;
                            },
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
              onPressed: () => isFormValid(),
              text: "Submit",
              textColor: Colors.white,
              backgroundColor: blueColor,
            ),
          ),
        ),
      ),
    );
  }
}
