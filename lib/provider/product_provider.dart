import 'package:flutter/material.dart';

import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  Product? _currentProduct;
  bool _isScanning = false;

  Product? get currentProduct => _currentProduct;
  bool get isScanning => _isScanning;

  void setProduct(Product product) {
    _currentProduct = product;
    notifyListeners();
  }

  void resetCurrentProduct() {
    _currentProduct = null;
    notifyListeners();
  }

  void startScanning() {
    _isScanning = true;
    notifyListeners();
  }

  void stopScanning() {
    _isScanning = false;
    notifyListeners();
  }
}
