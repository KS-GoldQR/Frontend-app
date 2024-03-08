import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/features/sales/models/sold_product_model.dart';

import '../features/orders/models/old_jwellery_model.dart';
import '../models/customer_model.dart';

class SalesProvider extends ChangeNotifier {
  final List<SoldProduct> _products = [];
  final List<OldJwellery> _oldProduct = [];
  Customer? _customer;

  List<SoldProduct> get products => _products;
  List<OldJwellery> get oldProducts => _oldProduct;
  Customer? get customer => _customer;

  void addProduct(SoldProduct product) {
    _products.add(product);
    notifyListeners();
  }

  void addOldProduct(OldJwellery oldJwellery) {
    _oldProduct.add(oldJwellery);
    notifyListeners();
  }

  void addCustomerDetails(Customer details) {
    _customer = details;
    notifyListeners();
  }

  void resetSales() {
    _products.clear();
    _oldProduct.clear();
    _customer = null;
    notifyListeners();
  }

  void resetOldProducts() {
    _oldProduct.clear();
    notifyListeners();
  }

  void resetCustomer() {
    _customer = null;
  }

  void removeProductItemAt(int index) {
    _products.removeAt(index);
    notifyListeners();
  }

  void removeOldProductItemAt(int index) {
    _oldProduct.removeAt(index);
    notifyListeners();
  }
}
