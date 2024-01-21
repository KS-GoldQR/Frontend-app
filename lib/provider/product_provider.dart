import 'package:flutter/material.dart';

import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  Product? _currentProduct;

  Product? get currentProduct => _currentProduct;

  void setProduct(Product product) {
    _currentProduct = product;
    notifyListeners();
  }

  void resetCurrentProduct() {
    _currentProduct = null;
    notifyListeners();
  }
}
