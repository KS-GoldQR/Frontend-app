import 'package:flutter/material.dart';
import 'package:grit_qr_scanner/models/sales_model.dart';

class SalesProvider extends ChangeNotifier {
  final List<SalesModel> _saleItems = [];

  List<SalesModel> get saleItems => _saleItems;

  void addSaleItem(SalesModel item) {
    _saleItems.add(item);
    notifyListeners();
  }

  void resetSaleItem() {
    _saleItems.clear();
    notifyListeners();
  }

    void removeItemAt(int index) {
    _saleItems.removeAt(index);
    notifyListeners();
  }
}
