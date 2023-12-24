// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first


class Product {
  String id;
  String image;
  double jarti;
  double jyala;
  String name;
  int owned_by;
  int sold;
  String stone;
  double stone_price;
  String type;
  double weight;
  Product({
    required this.id,
    required this.image,
    required this.jarti,
    required this.jyala,
    required this.name,
    required this.owned_by,
    required this.sold,
    required this.stone,
    required this.stone_price,
    required this.type,
    required this.weight,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
      'jarti': jarti,
      'jyala': jyala,
      'name': name,
      'owned_by': owned_by,
      'sold': sold,
      'stone': stone,
      'stone_price': stone_price,
      'type': type,
      'weight': weight,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      image: map['image'] as String,
      jarti: map['jarti'] as double,
      jyala: map['jyala'] as double,
      name: map['name'] as String,
      owned_by: map['owned_by'] as int,
      sold: map['sold'] as int,
      stone: map['stone'] as String,
      stone_price: map['stone_price'] as double,
      type: map['type'] as String,
      weight: map['weight'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source) as Map<String, dynamic>);
}
