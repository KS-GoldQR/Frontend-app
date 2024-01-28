import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/features/orders/models/old_jwellery_model.dart';
import 'package:grit_qr_scanner/features/orders/models/ordered_items_model.dart';

import '../models/customer_model.dart';

class OrderProvider with ChangeNotifier {
  final List<OrderedItems> _orderedItems = [];
final  List<OldJwellery> _oldJweleries = [];
  Customer? _customer;

  List<OrderedItems> get orderedItems => _orderedItems;
List<OldJwellery> get oldJweleries => _oldJweleries;
Customer? get customer => _customer;

  void addOrderedItems(OrderedItems order) {
    _orderedItems.add(order);
    notifyListeners();
  }

  void addOldJewelry(OldJwellery oldJewelry) {
    _oldJweleries.add(oldJewelry);
    notifyListeners();
  }

  void setCustomerDetails(Customer details) {
    _customer = details;
    notifyListeners();
  }

  void resetOrders() {
    _orderedItems.clear();
    _oldJweleries.clear();
    _customer = null;
    notifyListeners();
  }

  void resetOldJwelries() {
    _oldJweleries.clear();
    notifyListeners();
  }

  void resetCustomer() {
    _customer = null;
  }
}
