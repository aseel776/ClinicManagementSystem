import 'package:equatable/equatable.dart';

class AppointmentModel extends Equatable{

  int? id;
  DateTime? time;
  //convert to patientmodel
  String? patient;
  String? place;
  String? nextPhase;
  //either registered/unregistered
  String? status;
  /*
  normal: 'normal',
  waiting: 'waiting',
  emergency: 'emergency',
  external: 'external'
   */
  String? type;
  String? notes;
  int? reserveId;

  AppointmentModel({this.id, this.time, this.type, this.patient, this.place, this.nextPhase, this.notes, this.status, this.reserveId});

  AppointmentModel.fromJson(Map<String, dynamic> src){
    id = src['id'];
    time = DateTime.tryParse(src['date']);
    patient = src['patient']['name'];
    place = src['place'];
    nextPhase = src['phase'];
    type = src['type'];
    status = src['state'];
    notes = src['notes'];
    if(src.containsKey('reservation_id')){
      reserveId = src['reservation_id'];
    }
  }

  Map<String, dynamic> toJson(){
    //implement later
    return {};
  }

  @override
  List<Object?> get props => [];

}