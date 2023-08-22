import 'active_materials.dart';

class Medicine {
  int? id;
  int? concentration;
  String? name;
  String? category;

  // String? description;
  // List<ActiveMaterials>? anti;

  Medicine({this.id, this.concentration, this.name, this.category
      // this.description,
      // this.anti,
      });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
        id: json['id'],
        concentration: json['concentration'] is int ? json['concentration'] : json['concentration'].toInt(),
        name: json['name'],
        category: json['category']['name']
        // description: json['description'],
        // anti: List<ActiveMaterials>.from(
        //     json['anti']?.map((x) => ActiveMaterials.fromJson(x))),
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
