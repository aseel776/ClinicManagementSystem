import 'active_material_model.dart';

class MaterialsPaginationModel{
  List<ActiveMaterialModel>? materials;
  int? totalPages;
  int? currentPage;

  MaterialsPaginationModel({this.materials, this.currentPage, this.totalPages});
}