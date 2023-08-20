import 'package:clinic_management_system/features/appointments_sessions/data/models/appointment_model.dart';
import 'package:equatable/equatable.dart';

class AppointmentsPage extends Equatable{

  DateTime? date;
  List<AppointmentModel>? appointments;

  AppointmentsPage({this.date, this.appointments});

  AppointmentsPage.fromJson(Map<String, dynamic> source){
    date = source['date'];
    List<dynamic> temp = source['appointments'];
    appointments = temp.map((e) => AppointmentModel.fromJson(e)).toList();
  }

  @override
  List<Object?> get props => [];
}