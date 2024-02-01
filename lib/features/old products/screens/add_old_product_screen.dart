import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:grit_qr_scanner/features/old%20products/services/old_product_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../utils/form_validators.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/utils.dart';
import '../../../utils/widgets/custom_button.dart';

class AddOldProductScreen extends StatefulWidget {
  const AddOldProductScreen({super.key});

  @override
  State<AddOldProductScreen> createState() => _AddOldProductScreenState();
}

class _AddOldProductScreenState extends State<AddOldProductScreen> {
  final _addOldProductFormKey = GlobalKey<FormState>();
  final _modalProgressHUDKeyAboutOldProduct = GlobalKey();
  final OldProductService _oldProductService = OldProductService();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _stoneController = TextEditingController();
  final TextEditingController _stonePriceController = TextEditingController();
  final _descriptionFocus = FocusNode();
  final _nameFocus = FocusNode();
  final _weightFocus = FocusNode();
  final _stoneFocus = FocusNode();
  final _stonePriceFocus = FocusNode();
  late List<String> types;
  late String selectedType;
  bool _stonePriceFieldVisible = false;

  late List<String> weight;
  late String selectedWeight;
  File? image;
  int currentIndex = 0;
  bool isSubmitting = false;
  bool _dependenciesInitialized = false;

  Future<void> _pickImage(ImageSource source) async {
    image = await pickFile(context, source);
    setState(() {});
  }

  void isFormValid() async {
    if (_addOldProductFormKey.currentState!.validate()) {
      setState(() {
        isSubmitting = true;
      });
      await addOldProduct();
      setState(() {
        isSubmitting = false;
      });
    } else {}
  }

  Future<void> addOldProduct() async {
    var (rselectedWeightType, rselectedType) = translatedTypes(
        context: context,
        selectedWeightType: selectedWeight,
        selectedType: selectedType);

    await _oldProductService.addOldProduct(
      context: context,
      image: image,
      name: _nameController.text.trim(),
      productType: rselectedType ?? selectedType,
      weight: getWeight(double.tryParse(_weightController.text.trim())!,
          rselectedWeightType ?? selectedWeight),
      stone:
          _stoneController.text.isEmpty ? null : _stoneController.text.trim(),
      stonePrice: _stonePriceController.text.isEmpty
          ? null
          : double.tryParse(_stonePriceController.text.trim())!,
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
          content: Text(AppLocalizations.of(context)!.allProductsWillBeCleared),
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
      selectedWeight = AppLocalizations.of(context)!.gram;
      selectedType = AppLocalizations.of(context)!.asalChandi;
      _dependenciesInitialized = true;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _nameController.dispose();
    _weightController.dispose();
    _stoneController.dispose();
    _stonePriceController.dispose();
    _descriptionFocus.dispose();
    _nameFocus.dispose();
    _weightFocus.dispose();
    _stoneFocus.dispose();
    _stonePriceFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _onWillPop(context);
      },
      child: ModalProgressHUD(
        key: _modalProgressHUDKeyAboutOldProduct,
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
                    key: _addOldProductFormKey,
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
                                : image != null
                                    ? Image.file(
                                        image!,
                                        fit: BoxFit.contain,
                                        height: size.height * 0.2,
                                        width: double.infinity,
                                      )
                                    : DottedBorder(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.type,
                                style: customTextDecoration(),
                              ),
                              const Text(
                                "verify!",
                                style: TextStyle(color: Colors.red),
                              )
                            ],
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
