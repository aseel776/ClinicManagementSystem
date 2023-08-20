import 'package:clinic_management_system/features/active_materials_feature/data/models/active_material_model.dart';

class Disease {
  final int? id;
  final String name;
  // final String description;
  final List<ActiveMaterialModel>? antiMaterials;
  bool isFlipped;

  Disease({
    this.id,
    required this.name,
    // required this.description,
    this.antiMaterials,
    this.isFlipped = false,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    List<ActiveMaterialModel>? materialsList;
    if (json.containsKey('diseaseChemicalMaterials')) {
      List<dynamic> materialsData = json['diseaseChemicalMaterials'];
      materialsList = materialsData
          .map((materialData) =>
              ActiveMaterialModel.fromJson(materialData['chemical_material']))
          .toList();
    }

    return Disease(
      id: json['id'],
      name: json['name'],
      // description: json['description'],
      antiMaterials: materialsList,
      // isFlipped: json['isFlipped'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'diseaseName': name,
      'chemicalMaterialIds':
          antiMaterials?.map((material) => material.id).toList(),
    };
  }
}