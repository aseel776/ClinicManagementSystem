import 'package:equatable/equatable.dart';

class ActiveMaterialModel extends Equatable {
  int? id;
  String? name;
  //change type into ActiveMaterialModel
  List<ActiveMaterialModel>? antiMaterials;

  ActiveMaterialModel({this.id, this.name, this.antiMaterials});

  ActiveMaterialModel.fromJson(Map<String, dynamic> source) {
    
  
    id = source['id'];
    name = source['name'];
    if (source['conflicts'] != null) {
      List<dynamic> conflicts = source['conflicts'];
      antiMaterials =
          conflicts.map((c) => ActiveMaterialModel.fromJson(c)).toList();
    }
  }

  String toJson() {
    String string = "";
    //encoding
    return string;
  }

  @override
  List<Object?> get props => [id, name, antiMaterials];
}
