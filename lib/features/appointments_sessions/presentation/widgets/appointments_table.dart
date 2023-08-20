import 'package:clinic_management_system/features/appointments_sessions/presentation/states/appoitments/appointments_state.dart';
import 'package:clinic_management_system/features/appointments_sessions/presentation/states/appoitments/appoitments_provider.dart';
import 'package:clinic_management_system/features/appointments_sessions/presentation/states/control_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './/core/app_colors.dart';
import '../../data/models/appointment_model.dart';

class AppointmentsTable extends ConsumerStatefulWidget {
  final double tableWidth;
  final double tableHeight;

  const AppointmentsTable({
    super.key,
    required this.tableWidth,
    required this.tableHeight,
  });

  @override
  ConsumerState<AppointmentsTable> createState() => _AppointmentsTableState();
}

class _AppointmentsTableState extends ConsumerState<AppointmentsTable> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await ref.read(appointmentsProvider.notifier).getAllAppointments(ref.read(selectedDate).toString());
    });
  }


  @override
  Widget build(BuildContext context) {

    final state = ref.watch(appointmentsProvider);

    return SizedBox(
      width: widget.tableWidth,
      height: widget.tableHeight,
      child: state is LoadedAppointmentsState
          ? Column(
        children: [
          SizedBox(height: widget.tableHeight * .05),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columnSpacing: 0,
                horizontalMargin: widget.tableWidth * .025,
                columns: [
                  DataColumn(label: createTimeLabel('التوقيت')),
                  DataColumn(label: createPatientLabel('المريض')),
                  DataColumn(label: createPlace('مكان العلاج')),
                  DataColumn(label: createPhase('المرحلة')),
                  DataColumn(label: createText('ملاحظات')),
                  DataColumn(label: createText('العمليات')),
                ],
                rows: [
                  ...state.page.appointments!.map((e) => createTableRecord(e)).toList()
                ],
              ),
            ),
          ),
        ],
      )
          : state is LoadingAppointmentsState
          ? Container(color: Colors.yellow)
          : Container(color: Colors.red),
    );
  }

  createTableRecord(AppointmentModel app){
    Color rowColor;
    switch(app.type){
      case "normal":
        rowColor = Colors.lightGreen[200]!.withOpacity(.3);
        break;
      case "emergency":
         rowColor = Colors.red[200]!.withOpacity(.3);
         break;
      case "waiting":
        rowColor = Colors.orange[200]!.withOpacity(.3);
        break;
      case "external":
        rowColor = Colors.blue[200]!.withOpacity(.3);
        break;
      default:
        rowColor = Colors.yellow[200]!.withOpacity(.3);
    }
    return DataRow(
      color: MaterialStateProperty.all(rowColor),
      cells: [
        DataCell(createTimeLabel(app.time.toString().substring(11, 16))),
        DataCell(createPatientLabel(app.patient!)),
        DataCell(createPlace(app.place!)),
        DataCell(createPhase(app.nextPhase!)),
        DataCell(createNotes(app.notes!)),
        DataCell(createButtons()),
      ],
    );
  }

  createTimeLabel(String date){
    return SizedBox(
      width: widget.tableWidth * .075,
      child: createText(date),
    );
  }

  createPatientLabel(String patient){
    return SizedBox(
      width: widget.tableWidth * .2,
      child: createText(patient),
    );
  }

  createPlace(String place){
    return SizedBox(
      width: widget.tableWidth * .125,
      child: createText(place),
    );
  }

  createPhase(String phase){
    return SizedBox(
      width: widget.tableWidth * .1,
      child: createText(phase),
    );
  }
  
  createNotes(String notes){
    return SizedBox(
      width: widget.tableWidth * .2,
      child: createText(notes),
    );
  }

  createButtons(){
    return Container(
      width: widget.tableWidth * .25,
    );
  }

  createText(String title) {
    return Text(
      title,
      overflow: TextOverflow.fade,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 18,
        color: AppColors.black,
      ),
    );
  }
}