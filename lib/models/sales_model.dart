// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:grit_qr_scanner/models/product_model.dart';

class SalesModel {
  final Product product;
  final double price;
  final double weight;
  final double jyalaPercentage;
  final double jartiPercentage;
  SalesModel({
    required this.product,
    required this.price,
    required this.weight,
    required this.jyalaPercentage,
    required this.jartiPercentage,
  });
}
  