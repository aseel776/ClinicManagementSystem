import 'package:equatable/equatable.dart';

class ActiveMaterials extends Equatable {
  int? id;
  String? name;
  List<ActiveMaterials>? anti;

  ActiveMaterials({this.id, this.name, this.anti});

  factory ActiveMaterials.fromJson(Map<String, dynamic> json) {
    return ActiveMaterials(
      id: json['id'],
      name: json['name'],
      // anti: List<ActiveMaterials>.from(
      //     json['items']?.map((x) => ActiveMaterials.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items': anti?.map((x) => x.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, name];
}
