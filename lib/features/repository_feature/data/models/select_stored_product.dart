import 'package:clinic_management_system/features/repository_feature/data/models/product.dart';

class SelectStoredProduct {
  final DateTime? expirationDate;
  final int id;
  final double price;
  final int productId;
  final int quantity;
  final int totalQuantity;
  final Product product;

  SelectStoredProduct({
    this.expirationDate,
    required this.id,
    required this.price,
    required this.productId,
    required this.quantity,
    required this.totalQuantity,
    required this.product,
  });

  factory SelectStoredProduct.fromJson(Map<String, dynamic> json) {
    return SelectStoredProduct(
      expirationDate: json['expiration_date'] != null
          ? DateTime.parse(json['expiration_date'])
          : null,
      id: json['id'],
      price: json['price'].toDouble(),
      productId: json['product_id'],
      quantity: json['quantity'],
      totalQuantity: json['total_quantity'],
      product: Product.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expiration_date': expirationDate?.toIso8601String(),
      'id': id,
      'price': price,
      'product_id': productId,
      'quantity': quantity,
      'total_quantity': totalQuantity,
      'product': product.toJson(),
    };
  }
}
