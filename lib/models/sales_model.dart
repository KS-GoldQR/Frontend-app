// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:grit_qr_scanner/features/orders/models/old_jwellery_model.dart';
import 'package:grit_qr_scanner/features/sales/models/sold_product_model.dart';

class SalesModel {
  final String id;
  final String userId;
  final String customerName;
  final String customerPhone;
  final Map<String, dynamic> rate;
  final DateTime createdAt;
  final List<SoldProduct>? products;
  final List<OldJwellery>? oldProducts;

  SalesModel(
      {required this.id,
      required this.userId,
      required this.customerName,
      required this.customerPhone,
      required this.rate,
      required this.createdAt,
      required this.products,
      required this.oldProducts});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'rate': rate,
      'created_at': createdAt.millisecondsSinceEpoch,
      'products': products!.map((x) => x.toMap()).toList(),
      'old_products': oldProducts!.map((x) => x.toMap()).toList(),
    };
  }

  factory SalesModel.fromMap(Map<String, dynamic> map) {
    return SalesModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      customerName: map['customer_name'] as String,
      customerPhone: map['customer_phone'] as String,
      rate: Map<String, dynamic>.from((map['rate'] as Map<String, dynamic>)),
      createdAt: DateTime.tryParse(map['created_at'])!,
      products: (map['products'] as List<dynamic>?)
          ?.map<SoldProduct>(
              (x) => SoldProduct.fromMap(x as Map<String, dynamic>))
          .toList(),
      oldProducts: (map['old_products'] as List<dynamic>?)
          ?.map<OldJwellery>(
              (x) => OldJwellery.fromMap(x as Map<String, dynamic>))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SalesModel.fromJson(String source) =>
      SalesModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
