// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class Product {
  String id;
  String? image;
  double? jarti;
  double? jyala;
  String? name;
  int owned_by;
  int sold;
  String? stone;
  double? stone_price;
  String? productType;
  double? weight;
  String? rate;
  String owner_name;
  String owner_phone;
  String validSession;

  Product({
    required this.id,
    this.image,
    this.jarti,
    this.jyala,
    this.name,
    required this.owned_by,
    required this.sold,
    this.stone,
    this.stone_price,
    this.productType,
    this.weight,
    this.rate,
    required this.owner_name,
    required this.owner_phone,
    required this.validSession,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'jarti': jarti,
      'jyala': jyala,
      'name': name,
      'owned_by': owned_by,
      'sold': sold,
      'stone': stone,
      'stone_price': stone_price,
      'productType': productType,
      'weight': weight,
      'rate': rate,
      'owner_name': owner_name,
      'owner_phone': owner_phone,
      'validSession': validSession,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      image: map['image'] as String?,
      jarti: double.tryParse(map['jarti']) ?? 0.0,
      jyala: double.tryParse(map['jyala']) ?? 0.0,
      name: map['name'] as String?,
      owned_by: int.tryParse(map['owned_by']) ?? 0,
      sold: int.tryParse(map['sold']) ?? 0,
      stone: map['stone'] as String?,
      stone_price: double.tryParse(map['stone_price']) ?? 0.0,
      productType: map['productType'] as String?,
      weight: double.tryParse(map['weight']) ?? 0.0,
      rate: map['rate'] ?? "",
      owner_name: map['owner_name'] ?? "",
      owner_phone: map['owner_phone'] ?? "",
      validSession: map['validSession'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  Product copyWith({
    String? id,
    String? image,
    double? jarti,
    double? jyala,
    String? name,
    int? owned_by,
    int? sold,
    String? stone,
    double? stone_price,
    String? productType,
    double? weight,
    String? rate,
    String? owner_name,
    String? owner_phone,
    String? validSession,
  }) {
    return Product(
      id: id ?? this.id,
      image: image ?? this.image,
      jarti: jarti ?? this.jarti,
      jyala: jyala ?? this.jyala,
      name: name ?? this.name,
      owned_by: owned_by ?? this.owned_by,
      sold: sold ?? this.sold,
      stone: stone ?? this.stone,
      stone_price: stone_price ?? this.stone_price,
      productType: productType ?? this.productType,
      weight: weight ?? this.weight,
      rate: rate ?? this.rate,
      owner_name: owner_name ?? this.owner_name,
      owner_phone: owner_phone ?? this.owner_phone,
      validSession: validSession ?? this.validSession,
    );
  }
}
