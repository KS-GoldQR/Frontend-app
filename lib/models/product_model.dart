// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  double? price;
  String? customerName;
  String? customerAddress;
  String? customerPhone;
  DateTime? updatedAt;
  DateTime? soldAt;
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
    this.price,
    this.customerName,
    this.customerAddress,
    this.customerPhone,
    this.updatedAt,
    this.soldAt,
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
      'price': price,
      'customer_name': customerName,
      'customer_address': customerAddress,
      'customer_phone': customerPhone,
      'updated_at': updatedAt,
      'sold_at': soldAt,
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
      sold: map['sold'] != null ? int.tryParse(map['sold']) ?? 0 : 0,
      stone: map['stone'] as String?,
      stone_price: map['stone_price'] != "None"
          ? double.tryParse(map['stone_price'])
          : null, //from backend its None in response, what dart doesn't understands if its null
      productType: map['productType'] as String?,
      weight: double.tryParse(map['weight']) ?? 0.0,
      price: map['price'] != null ? double.tryParse(map['price']) : 0.0,
      customerName: map['customer_name'] as String?,
      customerAddress: map['customer_address'] as String?,
      customerPhone: map['customer_phone'] as String?,
      updatedAt: map.containsKey('updated_at')
          ? (map['updated_at'] != null
              ? DateTime.tryParse(map['updated_at'])
              : null)
          : null,
      soldAt: map.containsKey('sold_at')
          ? (map['sold_at'] != null ? DateTime.tryParse(map['sold_at']) : null)
          : null,
      owner_name: map['owner_name'] != null ? map['owner_name'] ?? "" : "",
      owner_phone: map['owner_phone'] != null ? map['owner_phone'] ?? "" : "",
      validSession:
          map['validSession'] != null ? map['validSession'] ?? "" : "",
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
    double? price,
    String? customerName,
    String? customerAddress,
    String? customerPhone,
    DateTime? updatedAt,
    DateTime? soldAt,
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
      stone_price: stone_price,
      productType: productType ?? this.productType,
      weight: weight ?? this.weight,
      price: price ?? this.price,
      customerName: customerName ?? this.customerName,
      customerAddress: customerAddress ?? this.customerAddress,
      customerPhone: customerPhone ?? this.customerPhone,
      updatedAt: updatedAt ?? this.updatedAt,
      soldAt: soldAt ?? this.soldAt,
      owner_name: owner_name ?? this.owner_name,
      owner_phone: owner_phone ?? this.owner_phone,
      validSession: validSession ?? this.validSession,
    );
  }
}
