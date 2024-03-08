// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SoldProduct {
  final String id;
  final String name;
  final String image;
  final String type;
  final double weight;
  final double rate;
  final double jyala;
  final double jarti;
  final String jartiType;
  final double amount;

  SoldProduct(
      {required this.id,
      required this.name,
      required this.image,
      required this.type,
      required this.weight,
      required this.rate,
      required this.jyala,
      required this.jarti,
      required this.jartiType,
      required this.amount});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image,
      'type':type,
      'weight': weight,
      'rate': rate,
      'jyala': jyala,
      'jarti': jarti,
      'jarti_type': jartiType,
      'amount': amount,
    };
  }

  factory SoldProduct.fromMap(Map<String, dynamic> map) {
    return SoldProduct(
      id: map['id'] as String,
      name: map['name'] as String,
      image: map['image'] as String,
      type: map['type'] as String,
      rate: map['rate'] as double,
      weight: map['weight'] as double,
      jyala: map['jyala'] as double,
      jarti: map['jarti'] as double,
      jartiType: map['jarti_type'] as String,
      amount: map['amount'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory SoldProduct.fromJson(String source) =>
      SoldProduct.fromMap(json.decode(source) as Map<String, dynamic>);
}
