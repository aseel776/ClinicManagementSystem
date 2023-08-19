import 'product.dart';

class StoredProduct {
  int? id;
  String? name;
  int? totalQuantity;

  StoredProduct({this.id, this.name, this.totalQuantity});

  // Factory method to create a StoredProduct instance from a JSON map
  factory StoredProduct.fromJson(Map<String, dynamic> json) {
    return StoredProduct(
      id: json['id'] as int?,
      name: json['name'] as String,
      totalQuantity: json['totalQuantity'] as int?,
    );
  }

  // Convert a StoredProduct instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name, // Convert the nested Product to JSON
      'totalQuantity': totalQuantity,
    };
  }
}
