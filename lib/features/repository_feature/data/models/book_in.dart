import 'package:clinic_management_system/features/repository_feature/data/models/product.dart';

class BookIn {
  final int id;
  final Product product;
  final double price;
  final int quantity;
  final double totalPrice;
  final DateTime? expirationDate;

  BookIn(
      {required this.id,
      required this.product,
      required this.price,
      required this.quantity,
      required this.totalPrice,
      this.expirationDate});

  factory BookIn.fromJson(Map<String, dynamic> json) {
    return BookIn(
      id: json['id'],
      product: Product.fromJson(json['product']),
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      totalPrice: json['total_price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'price': price,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }
}
