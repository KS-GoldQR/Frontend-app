import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Customer {
  String name;
  String phone;
  String address;
  DateTime expectedDeadline;
  double advance;
  Customer({
    required this.name,
    required this.phone,
    required this.address,
    required this.expectedDeadline,
    required this.advance,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'customer_name': name,
      'customer_phone': phone,
      'customer_address': address,
      'expected_deadline': expectedDeadline.millisecondsSinceEpoch,
      'advance_payment': advance,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      name: map['customer_name'] as String,
      phone: map['customer_phone'] as String,
      address: map['customer_address'] as String,
      expectedDeadline: DateTime.fromMillisecondsSinceEpoch(map['expected_deadline'] as int),
      advance: map['advance_payment'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) => Customer.fromMap(json.decode(source) as Map<String, dynamic>);
}
