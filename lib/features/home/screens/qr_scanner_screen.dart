import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/features/products/screens/about_product_screen.dart';
import 'package:grit_qr_scanner/features/products/screens/edit_product_screen.dart';
import 'package:grit_qr_scanner/features/products/services/product_service.dart';
import 'package:grit_qr_scanner/provider/user_provider.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../../models/product_model.dart';
import '../../../utils/global_variables.dart';
import '../../../utils/widgets/error_page.dart';

// ignore: must_be_immutable
class QRScannerScreen extends StatefulWidget {
  static const String routeName = '/qr-scanner-screen';
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
  );
  final ProductService _productService = ProductService();
  Product? product;
  bool isScanning = false;

  Future<void> getProductInfo(String productId, String sessionToken) async {
    try {
      setState(() {
        isScanning = true;
      });
      product =
          await _productService.viewProduct(context, productId, sessionToken);
      setState(() {
        isScanning = false;
      });
    } catch (e) {
      navigatorKey.currentState!.popAndPushNamed(
        ErrorPage.routeName,
        arguments: "Error Occurred - Bad Request",
      );
    }
  }

  Future<void> _cannotEdit() async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: 'Not Allowed',
      desc: 'product is not allowed to view/edit',
      btnOkText: 'Ok',
      btnOkColor: blueColor,
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    ).show();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final user = Provider.of<UserProvider>(context).user;
    return ModalProgressHUD(
      inAsyncCall: isScanning,
      opacity: 0.5,
      progressIndicator: const SpinKitChasingDots(
        color: blueColor,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "QR Scanner",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              color: Colors.black,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.torchState,
                builder: (context, state, child) {
                  switch (state) {
                    case TorchState.off:
                      return const Icon(Icons.flash_off, color: Colors.black);
                    case TorchState.on:
                      return const Icon(Icons.flash_on, color: Colors.red);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.toggleTorch(),
            ),
            IconButton(
              color: Colors.black,
              icon: ValueListenableBuilder(
                valueListenable: cameraController.cameraFacingState,
                builder: (context, state, child) {
                  switch (state) {
                    case CameraFacing.front:
                      return const Icon(Icons.camera_front);
                    case CameraFacing.back:
                      return const Icon(Icons.camera_rear);
                  }
                },
              ),
              iconSize: 32.0,
              onPressed: () => cameraController.switchCamera(),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Place the QR Code in the area",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Scanning will be started automatically",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                height: 450,
                width: 450,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: MobileScanner(
                    controller: cameraController,
                    onScannerStarted: (arguments) {
                      debugPrint(arguments.toString());
                    },
                    onDetect: (capture) async {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        debugPrint('Barcode found! ${barcode.rawValue}');
                      }
                      cameraController.stop();

                      try {
                        await getProductInfo(
                            barcodes[0].rawValue!, user.sessionToken);

                        if (product != null) {
                          if (product!.name == null &&
                              user.sessionToken.isEmpty) {
                            _cannotEdit();
                          } else if (product!.name == null) {
                            navigatorKey.currentState!.pushReplacementNamed(
                                EditProductScreen.routeName,
                                arguments: {
                                  'product': product,
                                  'fromAboutProduct': false,
                                });
                          } else {
                            navigatorKey.currentState!.pushReplacementNamed(
                                AboutProduct.routeName,
                                arguments: {
                                  'product': product,
                                });
                          }
                        }
                      } catch (e) {
                        debugPrint("Error while getting product info: $e");
                      }
                    },
                    placeholderBuilder: (p0, p1) {
                      return const SpinKitChasingDots(
                        color: Colors.green,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              const Text(
                "A product of Golden Nepal IT Solution",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
