import 'package:equatable/equatable.dart';

class TreatmentTypeModel extends Equatable{

  late final int? id;
  late final String? name;

  TreatmentTypeModel({this.id, this.name});

  TreatmentTypeModel.fromJson(Map<String, dynamic> source){
    id = source['id'];
    name = source['name'];
  }

  String toJson(){
    String string = "";
    //encoding
    return string;
  }

  @override
  List<Object?> get props => [id, name];

}