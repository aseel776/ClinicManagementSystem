import 'package:clinic_management_system/features/repository_feature/data/models/product.dart';

class BookOut {
  final int id;
  final int productId;
  final int quantity;
  final double totalPrice;
  final Product product;

  BookOut({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.totalPrice,
    required this.product,
  });

  factory BookOut.fromJson(Map<String, dynamic> json) {
    return BookOut(
      id: json['id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      totalPrice: json['total_price'],
      product: Product.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'quantity': quantity,
      'total_price': totalPrice,
      'product': product.toJson(),
    };
  }
}
