import 'package:clinic_management_system/features/active_materials_feature/data/models/active_material_model.dart';

class BadHabit {
  final int? id;
  final String name;
  final List<ActiveMaterialModel>? antiMaterials;

  BadHabit({this.id, required this.name, this.antiMaterials
      // required this.description,
      // required this.antiMaterials,
      });

  factory BadHabit.fromJson(Map<String, dynamic> json) {
    return BadHabit(
      id: json['id'],
      name: json['name'],
      // description: ""
      // description: json['description'],
      // antiMaterials: List<String>.from(json['antiMaterials']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'name': name,
      'chemical_material_id':
          antiMaterials!.map((material) => material.id).toList(),
    };
  }
}
