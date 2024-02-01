import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// // To parse this JSON data, do
// //
// //     final orderedItems = orderedItemsFromJson(jsonString);

// OrderedItems orderedItemsFromJson(String str) => OrderedItems.fromJson(json.decode(str));

// String orderedItemsToJson(OrderedItems data) => json.encode(data.toJson());

// class OrderedItems {
//     OrderedItemsClass orderedItems;

//     OrderedItems({
//         required this.orderedItems,
//     });

//     factory OrderedItems.fromJson(Map<String, dynamic> json) => OrderedItems(
//         orderedItems: OrderedItemsClass.fromJson(json["ordered_items"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "ordered_items": orderedItems.toJson(),
//     };
// }

// class OrderedItemsClass {
//     String itemName;
//     double wt;
//     String type;
//     double jarti;
//     double jyala;
//     String stone;
//     double stonePrice;
//     double totalPrice;

//     OrderedItemsClass({
//         required this.itemName,
//         required this.wt,
//         required this.type,
//         required this.jarti,
//         required this.jyala,
//         required this.stone,
//         required this.stonePrice,
//         required this.totalPrice,
//     });

//     factory OrderedItemsClass.fromJson(Map<String, dynamic> json) => OrderedItemsClass(
//         itemName: json["item_name"],
//         wt: json["wt"],
//         type: json["type"],
//         jarti: json["jarti"],
//         jyala: json["jyala"],
//         stone: json["stone"],
//         stonePrice: json["stone_price"],
//         totalPrice: json["total_price"],
//     );

//     Map<String, dynamic> toJson() => {
//         "item_name": itemName,
//         "wt": wt,
//         "type": type,
//         "jarti": jarti,
//         "jyala": jyala,
//         "stone": stone,
//         "stone_price": stonePrice,
//         "total_price": totalPrice,
//     };
// }

class OrderedItems {
  String itemName;
  double wt;
  String type;
  double jarti;
  double jyala;
  String? stone;
  double? stonePrice;
  double totalPrice;
  OrderedItems({
    required this.itemName,
    required this.wt,
    required this.type,
    required this.jarti,
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
      jyala: map['jyala'] as double,
      stone: map['stone'] as String?,
      stonePrice:
          map['stone_price'] != null ? map['stone_price'] as double : null,
      totalPrice: map['total_price'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderedItems.fromJson(String source) =>
      OrderedItems.fromMap(json.decode(source) as Map<String, dynamic>);
}
