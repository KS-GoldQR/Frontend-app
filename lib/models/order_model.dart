// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:nepali_date_picker/nepali_date_picker.dart';

import '../features/orders/models/old_jwellery_model.dart';
import '../features/orders/models/ordered_items_model.dart';

class Order {
  double remaining_payment;
  double advanced_payment;
  String user_id;
  List<OldJwellery>? old_jwellery;
  NepaliDateTime expected_deadline;
  String id;
  String customer_phone;
  String customer_name;
  List<OrderedItems>? ordered_items;
  Order({
    required this.remaining_payment,
    required this.advanced_payment,
    required this.user_id,
    this.old_jwellery,
    required this.expected_deadline,
    required this.id,
    required this.customer_phone,
    required this.customer_name,
    this.ordered_items,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'remaining_payment': remaining_payment,
      'advanced_payment': advanced_payment,
      'user_id': user_id,
      'old_jwellery': old_jwellery!.map((x) => x.toMap()).toList(),
      'expected_deadline': expected_deadline.millisecondsSinceEpoch,
      'id': id,
      'customer_phone': customer_phone,
      'customer_name': customer_name,
      'ordered_items': ordered_items!.map((x) => x.toMap()).toList(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      remaining_payment: double.tryParse(map['remaining_payment']) ?? 0.0,
      advanced_payment: double.tryParse(map['advanced_payment']) ?? 0.0,
      user_id: map['user_id'].toString(),
      old_jwellery: (map['old_jwellery'] as List<dynamic>?)
          ?.map<OldJwellery>(
              (x) => OldJwellery.fromMap(x as Map<String, dynamic>))
          .toList(),
      expected_deadline: NepaliDateTime.parse(map['expected_deadline']),
      id: map['id'].toString(),
      customer_phone: map['customer_phone'] as String,
      customer_name: map['customer_name'] as String,
      ordered_items: (map['ordered_items'] as List<dynamic>?)
          ?.map<OrderedItems>(
              (x) => OrderedItems.fromMap(x as Map<String, dynamic>))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);

  Order copyWith({
    double? remaining_payment,
    double? advanced_payment,
    String? user_id,
    List<OldJwellery>? old_jwellery,
    NepaliDateTime? expected_deadline,
    String? id,
    String? customer_phone,
    String? customer_name,
    List<OrderedItems>? ordered_items,
  }) {
    return Order(
      remaining_payment: remaining_payment ?? this.remaining_payment,
      advanced_payment: advanced_payment ?? this.advanced_payment,
      user_id: user_id ?? this.user_id,
      old_jwellery: old_jwellery ?? this.old_jwellery,
      expected_deadline: expected_deadline ?? this.expected_deadline,
      id: id ?? this.id,
      customer_phone: customer_phone ?? this.customer_phone,
      customer_name: customer_name ?? this.customer_name,
      ordered_items: ordered_items ?? this.ordered_items,
    );
  }
}
