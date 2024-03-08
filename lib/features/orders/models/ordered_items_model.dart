import 'dart:convert';

class OrderedItems {
  String itemName;
  double wt;
  String type;
  double jarti;
  String jartiType;
  double jyala;
  String? stone;
  double? stonePrice;
  double totalPrice;
  OrderedItems({
    required this.itemName,
    required this.wt,
    required this.type,
    required this.jarti,
    required this.jartiType,
    required this.jyala,
    this.stone,
    this.stonePrice,
    required this.totalPrice,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'item_name': itemName,
      'wt': wt,
      'type': type,
      'jarti': jarti,
      'jarti_type': jartiType,
      'jyala': jyala,
      'stone': stone,
      'stone_price': stonePrice,
      'total_price': totalPrice,
    };
  }

  factory OrderedItems.fromMap(Map<String, dynamic> map) {
    return OrderedItems(
      itemName: map['item_name'] as String,
      wt: map['wt'] as double,
      type: map['type'] as String,
      jarti: map['jarti'] as double,
      jartiType:
          map.containsKey('jarti_type') ? map['jarti_type'] as String : "",
      jyala: map['jyala'] as double,
      stone: map['stone'] as String?,
      stonePrice: map['stone_price'] != null
          ? double.tryParse(map['stone_price']) as double
          : null,
      totalPrice: map['total_price'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderedItems.fromJson(String source) =>
      OrderedItems.fromMap(json.decode(source) as Map<String, dynamic>);
}
