import 'dart:convert';

class OldJwellery {
  String itemName;
  double wt;
  String type;
  String? stone;
  double? stonePrice;
  double price;
  double? charge;
  double? loss;
  double? rate;
  OldJwellery({
    required this.itemName,
    required this.wt,
    required this.type,
    this.stone,
    this.stonePrice,
    required this.price,
    this.charge,
    this.loss,
    this.rate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'item_name': itemName,
      'wt': wt,
      'type': type,
      'stone': stone,
      'stone_price': stonePrice,
      'price': price,
      'charge': charge,
      'loss': loss,
      'rate': rate,
    };
  }

  factory OldJwellery.fromMap(Map<String, dynamic> map) {
    return OldJwellery(
      itemName: map['item_name'] as String,
      wt: map['wt'] as double,
      type: map['type'] as String,
      stone: map['stone'] as String?,
      price: map['price'] as double,
      stonePrice:
          map['stone_price'] != null ? map['stone_price'] as double? : null,
      charge: map.containsKey('charge')
          ? map['charge'] != null
              ? map['charge'] as double?
              : null
          : null,
      loss: map['loss'] != null ? map['loss'] as double? : null,
      rate: map['rate'] != null ? map['rate'] as double? : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OldJwellery.fromJson(String source) =>
      OldJwellery.fromMap(json.decode(source) as Map<String, dynamic>);
}
