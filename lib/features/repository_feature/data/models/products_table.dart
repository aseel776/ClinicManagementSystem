import 'package:clinic_management_system/features/repository_feature/data/models/product.dart';

class ProductsTable {
  List<Product>? products;
  int? totalPages;
  ProductsTable({this.products, this.totalPages});
}
