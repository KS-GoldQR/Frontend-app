import 'dart:convert';

import 'package:nepali_date_picker/nepali_date_picker.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Customer {
  String name;
  String? phone;
  String? address;
  NepaliDateTime? expectedDeadline;
  double? advance;
  double? remainingPayment;
  Customer({
    required this.name,
    this.phone,
    this.address,
    this.expectedDeadline,
    this.advance,
    this.remainingPayment,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customer_name': name,
      'customer_phone': phone,
      'customer_address': address,
      'expected_deadline': expectedDeadline?.millisecondsSinceEpoch,
      'advance_payment': advance,
      'remaining_payment': remainingPayment,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      name: map['customer_name'] as String,
      phone: map['customer_phone'] as String?,
      address: map['customer_address'] as String?,
      expectedDeadline:
          NepaliDateTime.tryParse(map['expected_deadline'].toString()),
      advance: double.tryParse(map['advance_payment']),
      remainingPayment: double.tryParse(map['remaining_payment']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) =>
      Customer.fromMap(json.decode(source) as Map<String, dynamic>);
}
