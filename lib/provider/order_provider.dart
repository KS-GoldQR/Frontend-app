import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/features/orders/models/old_jwellery_model.dart';
import 'package:grit_qr_scanner/features/orders/models/ordered_items_model.dart';

import '../models/customer_model.dart';

class OrderProvider with ChangeNotifier {
  final List<OrderedItems> _orderedItems = [];
  final List<OldJwellery> _oldJwelleries = [];
  Customer? _customer;

  List<OrderedItems> get orderedItems => _orderedItems;
  List<OldJwellery> get oldJwelleries => _oldJwelleries;
  Customer? get customer => _customer;

  void addOrderedItems(OrderedItems order) {
    _orderedItems.add(order);
    debugPrint("adding in provider");
    notifyListeners();
  }

  void addOldJwellery(OldJwellery oldJwellery) {
    _oldJwelleries.add(oldJwellery);
    notifyListeners();
  }

  void setCustomerDetails(Customer details) {
    _customer = details;
    notifyListeners();
  }

  void resetOrders() {
    _orderedItems.clear();
    _oldJwelleries.clear();
    _customer = null;
    notifyListeners();
  }

  void resetOldJwelries() {
    _oldJwelleries.clear();
    notifyListeners();
  }

  void resetCustomer() {
    _customer = null;
  }

  void removeOrderedItemAt(int index) {
    _orderedItems.removeAt(index);
    notifyListeners();
  }

  void removeOldJwelleryItemAt(int index) {
    _oldJwelleries.removeAt(index);
    notifyListeners();
  }
}
