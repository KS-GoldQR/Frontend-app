import 'dart:convert';

import 'package:nepali_date_picker/nepali_date_picker.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class OldProductModel {
  String productType;
  double rate;
  double? loss;
  double? charge;
  String ownedBy;
  String name;
  double weight;
  NepaliDateTime date;
  String? image;
  double? stonePrice;
  String? stone;
  String id;
  double? jyala;
  double? jarti;
  double? price;
  OldProductModel({
    required this.productType,
    required this.rate,
    this.loss,
    this.charge,
    required this.ownedBy,
    required this.name,
    required this.weight,
    required this.date,
    this.image,
    this.stonePrice,
    this.stone,
    required this.id,
    this.jyala,
    this.jarti,
    this.price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productType': productType,
      'rate': rate,
      'loss': loss,
      'charge': charge,
      'owned_by': ownedBy,
      'name': name,
      'weight': weight,
      'date': date.millisecondsSinceEpoch,
      'image': image,
      'stone_price': stonePrice,
      'stone': stone,
      'id': id,
      'jyala': jyala,
      'jarti': jarti,
      'price': price,
    };
  }

  factory OldProductModel.fromMap(Map<String, dynamic> map) {
    return OldProductModel(
      productType: map['productType'] as String,
      rate: double.tryParse(map['rate'])!,
      loss: map['loss'] != null ? double.tryParse(map['loss']) : null,
      charge: map['charge'] != null ? double.tryParse(map['charge']) : null,
      ownedBy: map['owned_by'] as String,
      name: map['name'] as String,
      weight: double.tryParse(map['weight'])!,
      date: NepaliDateTime.tryParse(map['date'])!,
      image: map['image'] as String?,
      stonePrice: map['stone_price'] != null
          ? double.tryParse(map['stone_price'])
          : null,
      stone: map['stone'] != null ? map['stone'] as String? : null,
      id: map['id'] as String,
      jyala: map['jyala'] != null ? double.tryParse(map['jyala']) : null,
      jarti: map['jarti'] != null ? double.tryParse(map['jarti']) : null,
      price: map['price'] != null ? double.tryParse(map['price']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OldProductModel.fromJson(String source) =>
      OldProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
