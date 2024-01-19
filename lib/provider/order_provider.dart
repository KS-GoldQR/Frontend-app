import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/features/orders/models/old_jwellery_model.dart';
import 'package:grit_qr_scanner/features/orders/models/ordered_items_model.dart';

import '../models/customer_model.dart';

class OrderProvider with ChangeNotifier {
  List<OrderedItems> orderedItems = [];
  List<OldJwellery> oldJewelries = [];
  Customer? customer;

  void addOrderedItems(OrderedItems order) {
    orderedItems.add(order);
    notifyListeners();
  }

  void addOldJewelry(OldJwellery oldJewelry) {
    oldJewelries.add(oldJewelry);
    notifyListeners();
  }

  void setCustomerDetails(Customer details) {
    customer = details;
    notifyListeners();
  }

  void resetOrders() {
    orderedItems = [];
    oldJewelries = [];
    customer = null;
    notifyListeners();
  }

  void resetOldJwelries() {
    oldJewelries = [];
    notifyListeners();
  }

  void resetCustomer() {
    customer = null;
  }
}
