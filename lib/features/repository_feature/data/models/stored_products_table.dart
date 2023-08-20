import 'package:clinic_management_system/features/repository_feature/data/models/stored_product.dart';

class StoredProductsTable {
  List<StoredProduct>? products;
  int? totalPages;
  StoredProductsTable({this.products, this.totalPages});
}
