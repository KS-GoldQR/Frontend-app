import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/features/home/screens/qr_scanner_screen.dart';
import 'package:grit_qr_scanner/features/products/screens/about_product_screen.dart';
import 'package:grit_qr_scanner/features/products/services/product_service.dart';
import 'package:grit_qr_scanner/utils/form_validators.dart';
import 'package:grit_qr_scanner/utils/widgets/custom_button.dart';
import 'package:grit_qr_scanner/utils/global_variables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../utils/utils.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product-screen';
  final Map<String, dynamic> args;
  const EditProductScreen({super.key, required this.args});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _addProductFormKey = GlobalKey<FormState>();
  GlobalKey _modalProgressHUDKeyEditProduct = GlobalKey();
  final ProductService _productService = ProductService();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _stoneController = TextEditingController();
  final TextEditingController _stonePriceController = TextEditingController();
  final TextEditingController _jyalaController = TextEditingController();
  final TextEditingController _jartiController = TextEditingController();
  final _descriptionFocus = FocusNode();
  final _nameFocus = FocusNode();
  final _weightFocus = FocusNode();
  final _stoneFocus = FocusNode();
  final _stonePriceFocus = FocusNode();
  final _jyalaFocus = FocusNode();
  final _jartiFocus = FocusNode();
  bool _dependenciesInitialized = false;
  bool _stonePriceFieldVisible = false;
  late List<String> types;
  late String selectedProductType;
  late List<String> jartiWeightTypeList;
  late List<String> weight;
  late String selectedWeight;
  late String selectedJartiWeightType;
  File? image;
  int currentIndex = 0;
  bool isSubmitting = false;

  Future<void> _pickImage(ImageSource source) async {
    image = await pickFile(context, source);
    setState(() {});
  }

  void isFormValid() async {
    if (_addProductFormKey.currentState!.validate()) {
      setState(() {
        isSubmitting = true;
      });
      if (widget.args['fromRouteName'] == QRScannerScreen.routeName) {
        await setProduct();
      } else {
        await editProduct();
      }
      setState(() {
        isSubmitting = false;
      });
    } else {}
  }

//image will be file type, sessiontoken will be dynamic
  Future<void> editProduct() async {
    var (rselectedWeightType, rselectedType, rselectedJartiWeightType) =
        translatedTypes(
            context: context,
            selectedWeightType: selectedWeight,
            selectedProductType: selectedProductType,
            selectedJartiWeightType: selectedJartiWeightType);

    double jarti = double.tryParse(_jartiController.text.trim())!;

    await _productService.editProduct(
      context: context,
      productId: widget.args['product'].id,
      image: image,
      name: _nameController.text.trim(),
      productType: rselectedType ?? selectedProductType,
      weight: getWeightInGram(double.tryParse(_weightController.text.trim())!,
          rselectedWeightType ?? selectedWeight),
      stone:
          _stoneController.text.isEmpty ? null : _stoneController.text.trim(),
      stonePrice: _stoneController.text.isEmpty
          ? null
          : _stonePriceController.text.isEmpty
              ? null
              : double.tryParse(_stonePriceController.text.trim())!,
      jyala: double.tryParse(_jyalaController.text.trim())!,
      jarti: jarti,
      jartiType: rselectedJartiWeightType!,
    );
  }

  Future<void> setProduct() async {
    var (rselectedWeightType, rselectedType, rselectedJartiWeightType) =
        translatedTypes(
            context: context,
            selectedWeightType: selectedWeight,
            selectedProductType: selectedProductType,
            selectedJartiWeightType: selectedJartiWeightType);

    double jarti = double.tryParse(_jartiController.text.trim())!;

    await _productService.setProduct(
      context: context,
      productId: widget.args['product'].id,
      image: image,
      name: _nameController.text.trim(),
      productType: rselectedType ?? selectedProductType,
      weight: getWeightInGram(double.tryParse(_weightController.text.trim())!,
          rselectedWeightType ?? selectedWeight),
      stone:
          _stoneController.text.isEmpty ? null : _stoneController.text.trim(),
      stonePrice: _stonePriceController.text.isEmpty
          ? null
          : double.tryParse(_stonePriceController.text.trim())!,
      jyala: double.tryParse(_jyalaController.text.trim())!,
      jarti: jarti,
      jartiType: rselectedJartiWeightType!,
    );
  }

  Future<void> _showChoiceDialog() async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.rightSlide,
      title: AppLocalizations.of(context)!.uploadImage,
      desc: AppLocalizations.of(context)!.chooseToUploadImage,
      btnOkText: AppLocalizations.of(context)!.gallery,
      btnCancelText: AppLocalizations.of(context)!.camera,
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

  void _onWillPop(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.quitEdit),
          content: Text(AppLocalizations.of(context)!.allProgressWillDisappear),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.no),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.yes),
            ),
          ],
        );
      },
    );
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void didChangeDependencies() {
    if (!_dependenciesInitialized) {
      weight = [
        AppLocalizations.of(context)!.tola,
        AppLocalizations.of(context)!.gram,
        AppLocalizations.of(context)!.laal,
      ];

      types = [
        AppLocalizations.of(context)!.chhapawal,
        AppLocalizations.of(context)!.tejabi,
        AppLocalizations.of(context)!.asalChandi
      ];

      jartiWeightTypeList = getJartiWeightType(context);
      //not work for set product because selectedProductType is not initailized at that time
      // selectedProductType = selectedProductType == "Tejabi"
      //     ? AppLocalizations.of(context)!.tejabi
      //     : selectedProductType == "Chhapawal"
      //         ? AppLocalizations.of(context)!.tejabi
      //         : AppLocalizations.of(context)!.asalChandi;

      if (widget.args['fromRouteName'] == QRScannerScreen.routeName) {
        selectedProductType = AppLocalizations.of(context)!.asalChandi;
      } else {
        selectedProductType = selectedProductType == "Tejabi"
            ? AppLocalizations.of(context)!.tejabi
            : selectedProductType == "Chhapawal"
                ? AppLocalizations.of(context)!.chhapawal
                : AppLocalizations.of(context)!.asalChandi;
      }
      selectedWeight = AppLocalizations.of(context)!.gram;
      // selectedJartiWeightType = AppLocalizations.of(context)!.laal;
      selectedJartiWeightType = widget.args['product'].jartiType == "%"
          ? "%"
          : translatedTypes(
                  context: context,
                  selectedWeightType: null,
                  selectedProductType: null,
                  selectedJartiWeightType: widget.args['product'].jartiType)
              .$3!;
      // widget.args['product'].jartiType == "Laal" ? "Laal" : "%";
      _dependenciesInitialized = true;

      debugPrint(widget.args['product'].jartiType);
    }

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    if (widget.args['fromRouteName'] == AboutProduct.routeName) {
      _nameController.text = widget.args['product'].name;
      selectedProductType = widget.args['product'].productType;
      _weightController.text = widget.args['product'].weight.toString();
      selectedJartiWeightType =
          widget.args['product'].jartiType == "Laal" ? "Laal" : "%";

      debugPrint("$selectedJartiWeightType heeere");
      if (widget.args['product'].stone != "None") {
        _stoneController.text = widget.args['product'].stone;
      }
      if (widget.args['product'].stone_price != null) {
        _stonePriceController.text =
            widget.args['product'].stone_price.toString();
      }
      _jyalaController.text = widget.args['product'].jyala.toString();
      _jartiController.text = widget.args['product'].jarti.toString();

      if (_stoneController.text.isNotEmpty) {
        _stonePriceFieldVisible = true;
      }
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
    _descriptionFocus.dispose();
    _nameFocus.dispose();
    _weightFocus.dispose();
    _stoneFocus.dispose();
    _stonePriceFocus.dispose();
    _jyalaFocus.dispose();
    _jartiFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(selectedJartiWeightType);
    final size = MediaQuery.sizeOf(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _onWillPop(context);
      },
      child: ModalProgressHUD(
        key: _modalProgressHUDKeyEditProduct,
        inAsyncCall: isSubmitting,
        progressIndicator: const SpinKitRotatingCircle(color: blueColor),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.editItem,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.alterFormToEditProduct,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
                            focusNode: _descriptionFocus,
                            onFieldSubmitted: (value) => _fieldFocusChange(
                                context, _descriptionFocus, _nameFocus),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            maxLines: null,
                            decoration: const InputDecoration.collapsed(
                              hintText: "Enter the description for the product",
                            ),
                            // autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            child: image != null
                                ? Image.file(
                                    image!,
                                    fit: BoxFit.contain,
                                    height: size.height * 0.2,
                                    width: double.infinity,
                                  )
                                : widget.args['product'].image == null
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
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                                AppLocalizations.of(context)!
                                                    .selectProductImages,
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: widget.args['product'].image,
                                        fit: BoxFit.contain,
                                        height: size.height * 0.2,
                                        width: double.infinity,
                                        errorWidget: (context, url, error) =>
                                            Center(
                                                child: Text(AppLocalizations.of(
                                                        context)!
                                                    .errorGettingImage)),
                                      ),
                          ),
                          const Gap(10),
                          Text(
                            AppLocalizations.of(context)!.productName,
                            style: customTextDecoration(),
                          ),
                          const Gap(5),
                          TextFormField(
                            controller: _nameController,
                            focusNode: _nameFocus,
                            onFieldSubmitted: (value) => _fieldFocusChange(
                                context, _nameFocus, _weightFocus),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: blueColor,
                            decoration: customTextfieldDecoration(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) => validateName(value!, context),
                          ),
                          const Gap(10),
                          Text(
                            AppLocalizations.of(context)!.type,
                            style: customTextDecoration(),
                          ),
                          const Gap(5),
                          DropdownButtonFormField<String>(
                            value: selectedProductType,
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
                                selectedProductType = value!;
                              });
                            },
                            decoration: customTextfieldDecoration(),
                          ),
                          const Gap(10),
                          Text(
                            AppLocalizations.of(context)!.weight,
                            style: customTextDecoration(),
                          ),
                          const Gap(5),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _weightController,
                                  focusNode: _weightFocus,
                                  onFieldSubmitted: (value) =>
                                      _fieldFocusChange(
                                          context, _weightFocus, _stoneFocus),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  textInputAction: TextInputAction.next,
                                  decoration: customTextfieldDecoration(),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) =>
                                      validateWeight(value!, context),
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
                            AppLocalizations.of(context)!.stone,
                            style: customTextDecoration(),
                          ),
                          const Gap(5),
                          TextFormField(
                            controller: _stoneController,
                            focusNode: _stoneFocus,
                            onFieldSubmitted: (value) => _fieldFocusChange(
                                context, _stoneFocus, _stonePriceFocus),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: blueColor,
                            decoration: customTextfieldDecoration(),
                            onChanged: (value) {
                              setState(() {
                                _stonePriceFieldVisible = value.isNotEmpty;
                                if (!_stonePriceFieldVisible) {
                                  _stonePriceController.text = "";
                                }
                              });
                            },
                          ),
                          const Gap(10),
                          Visibility(
                            visible: _stonePriceFieldVisible,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.stonePrice,
                                  style: customTextDecoration(),
                                ),
                                const Gap(5),
                                TextFormField(
                                  controller: _stonePriceController,
                                  focusNode: _stonePriceFocus,
                                  onFieldSubmitted: (value) =>
                                      _stonePriceFocus.unfocus(),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  textInputAction: TextInputAction.done,
                                  cursorColor: blueColor,
                                  decoration: customTextfieldDecoration(),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) =>
                                      validateStonePrice(value!, context),
                                ),
                              ],
                            ),
                          ),
                          const Gap(10),
                          Text(
                            "${AppLocalizations.of(context)!.jyala} ",
                            style: customTextDecoration(),
                          ),
                          const Gap(5),
                          TextFormField(
                            controller: _jyalaController,
                            focusNode: _jyalaFocus,
                            onFieldSubmitted: (value) => _fieldFocusChange(
                                context, _jyalaFocus, _jartiFocus),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            textInputAction: TextInputAction.next,
                            cursorColor: blueColor,
                            decoration: customTextfieldDecoration(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                validateJyala(value!, context),
                          ),
                          const Gap(10),
                          Text(
                            "${AppLocalizations.of(context)!.jarti} ",
                            style: customTextDecoration(),
                          ),
                          const Gap(5),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _jartiController,
                                  focusNode: _jartiFocus,
                                  onFieldSubmitted: (value) =>
                                      _jartiFocus.unfocus(),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  textInputAction: TextInputAction.done,
                                  cursorColor: blueColor,
                                  decoration: customTextfieldDecoration(),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) =>
                                      validateJarti(value!, context),
                                ),
                              ),
                              const Gap(10),
                              Expanded(
                                flex: 1,
                                child: DropdownButtonFormField<String>(
                                  value: selectedJartiWeightType,
                                  iconEnabledColor: const Color(0xFFC3C3C3),
                                  iconDisabledColor: const Color(0xFFC3C3C3),
                                  iconSize: 25,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                  items: jartiWeightTypeList.map((category) {
                                    return DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(category),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedJartiWeightType = value!;
                                    });
                                  },
                                  decoration: customTextfieldDecoration(),
                                ),
                              ),
                            ],
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
