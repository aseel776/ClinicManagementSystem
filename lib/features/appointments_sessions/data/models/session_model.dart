import 'package:clinic_management_system/features/appointments_sessions/data/models/appointment_model.dart';
import 'package:clinic_management_system/features/appointments_sessions/data/models/patient_lab_order.dart';
import 'package:clinic_management_system/features/appointments_sessions/data/models/pres_input_model.dart';
import 'package:clinic_management_system/features/appointments_sessions/data/models/sessionInputModel.dart';
import 'package:equatable/equatable.dart';

class SessionModel extends Equatable{

  int? id;
  AppointmentModel? app;
  List<SessionInputModel>? inputs;
  List<PrescriptionInput>? pres;
  PatientLabOrderModel? order;

  SessionModel({this.order, this.inputs, this.app, this.pres, this.id});

  SessionModel.fromJson(Map<String, dynamic> src){

  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = {};
    
    map.putIfAbsent('patient_id', () => app!.patient!.id!);
    map.putIfAbsent('patiient_appointment_id', () => app!.id!);
    map.putIfAbsent('CreatePatientTreatmentDoneStepFromSessionInput', () => inputs!.map((e) => e.toJson()).toList());
    if(pres != null){
      Map<String, dynamic> temp = {
        'createPatientPerscrptionsMedicienInput': pres!.map((e) => e.toJson()).toList()
      };
      map.putIfAbsent('createPatientPerscrptionFromSessionInput', () => temp);
    }
    if(order != null){
      map.putIfAbsent('createPatientLabOrderFromSessionInput', () => order!.toJson());
    }

    return map;
  }


  @override
  List<Object?> get props => [];
}