import 'package:equatable/equatable.dart';

class PatientLabOrderModel extends Equatable{

  int? id;
  String? createdAt;
  String? deliverAt;
  String? degree;
  String? type;
  String? directions;
  int? serviceId;
  int? patientId;
  List<String>? notations;
  String? serviceName;
  int? labId;
  String? labName;
  int? sessionId;

  PatientLabOrderModel({
    this.id,
    this.patientId,
    this.type,
    this.createdAt,
    this.degree,
    this.deliverAt,
    this.directions,
    this.serviceId,
    this.notations,
    this.labId,
    this.labName,
    this.serviceName,
    this.sessionId,
  });

  PatientLabOrderModel.fromJson(Map<String, dynamic> src){
    id = src['id'];
    createdAt = src['created_at'];
    deliverAt = src['deliver_at'];
    degree = src['degree'];
    type= src['type'];
    serviceId = src['lab_order_id'];
    patientId = src['patient_id'];
    notations = src['notation'];
    sessionId = src['patient_session_id'];
    if(src.containsKey('directions')){
      directions = src['directions'];
    }
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = {};
    map.putIfAbsent('created_at', () => createdAt);
    map.putIfAbsent('deliver_at', () => deliverAt);
    map.putIfAbsent('degree', () => degree);
    map.putIfAbsent('type', () => type);
    map.putIfAbsent('directions', () => directions);
    map.putIfAbsent('lab_order_id', () => serviceId);
    map.putIfAbsent('notation', () => notations);
    map.putIfAbsent('patient_id', () => patientId);
    return map;
  }

  @override
  List<Object?> get props => [createdAt, deliverAt, degree, type];
}