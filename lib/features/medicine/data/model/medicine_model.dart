import 'package:clinic_management_system/features/active_materials_feature/data/models/active_material_model.dart';

class Medicine {
  int? id;
  int? concentration;
  String? name;
  String? category;
  List<ActiveMaterialModel>? anti;

  Medicine({
    this.id,
    this.concentration,
    this.name,
    this.category,
    // this.description,
    this.anti,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    List<ActiveMaterialModel>? materialsList;
    if (json.containsKey('medicineChemicalMaterials')) {
      List<dynamic> materialsData = json['medicineChemicalMaterials'];
      materialsList = materialsData
          .map((materialData) =>
              ActiveMaterialModel.fromJson(materialData['chemical_material']))
          .toList();
    }
    // final List<dynamic> materialsData = json['medicineChemicalMaterials'];

    // List<ActiveMaterialModel> materialsList = materialsData
    //     .map((materialData) =>
    //         ActiveMaterialModel.fromJson(materialData['chemical_material']))
    //     .toList();

    return Medicine(
      id: json['id'],
      concentration: json['concentration'].toInt(),
      name: json['name'],
      category: json['category']['name'],
      anti: materialsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'concentration': concentration,
      'name': name,
      'category': category
      // 'description': description,
      // 'anti': anti?.map((x) => x.toJson()).toList(),
    };
  }
}
