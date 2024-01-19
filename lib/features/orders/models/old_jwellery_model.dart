import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// // To parse this JSON data, do
// //
// //     final oldJwellery = oldJwelleryFromJson(jsonString);

// import 'dart:convert';

// OldJwellery oldJwelleryFromJson(String str) =>
//     OldJwellery.fromJson(json.decode(str));

// String oldJwelleryToJson(OldJwellery data) => json.encode(data.toJson());

// class OldJwellery {
//   OldJwelleryClass oldJwellery;

//   OldJwellery({
//     required this.oldJwellery,
//   });

//   factory OldJwellery.fromJson(Map<String, dynamic> json) => OldJwellery(
//         oldJwellery: OldJwelleryClass.fromJson(json["old_jwellery"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "old_jwellery": oldJwellery.toJson(),
//       };
// }

// class OldJwelleryClass {
//   String itemName;
//   double wt;
//   String type;
//   String stone;
//   double stonePrice;
//   double price;

//   OldJwelleryClass({
//     required this.itemName,
//     required this.wt,
//     required this.type,
//     required this.stone,
//     required this.stonePrice,
//     required this.price,
//   });

//   factory OldJwelleryClass.fromJson(Map<String, dynamic> json) =>
//       OldJwelleryClass(
//         itemName: json["item_name"],
//         wt: json["wt"],
//         type: json["type"],
//         stone: json["stone"],
//         stonePrice: json["stone_price"],
//         price: json["price"],
//       );

//   Map<String, dynamic> toJson() => {
//         "item_name": itemName,
//         "wt": wt,
//         "type": type,
//         "stone": stone,
//         "stone_price": stonePrice,
//         "price": price,
//       };
// }

class OldJwellery {
  String itemName;
  double wt;
  String type;
  String stone;
  double stonePrice;
  double price;
  OldJwellery({
    required this.itemName,
    required this.wt,
    required this.type,
    required this.stone,
    required this.stonePrice,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'item_name': itemName,
      'wt': wt,
      'type': type,
      'stone': stone,
      'stone_price': stonePrice,
      'price': price,
    };
  }

  factory OldJwellery.fromMap(Map<String, dynamic> map) {
    return OldJwellery(
      itemName: map['item_name'] as String,
      wt: map['wt'] as double,
      type: map['type'] as String,
      stone: map['stone'] as String,
      stonePrice: map['stone_price'] as double,
      price: map['price'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory OldJwellery.fromJson(String source) => OldJwellery.fromMap(json.decode(source) as Map<String, dynamic>);
}
