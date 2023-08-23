import 'package:clinic_management_system/features/appointments_sessions/presentation/widgets/new_session.dart';
import 'package:clinic_management_system/features/appointments_sessions/presentation/widgets/upsert_appointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import './/core/app_colors.dart';
import '../states/control_states.dart';
import '../../data/models/appointment_model.dart';
import '../states/appointments/appointments_state.dart';
import '../states/appointments/appointments_provider.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(appointmentsProvider.notifier)
          .getAllAppointments(ref.read(selectedDate).toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appointmentsProvider);

    return SizedBox(
      width: widget.tableWidth,
      height: widget.tableHeight,
      child: state is LoadedAppointmentsState
          ? (state is LoadingAppointmentsState)
              ? LoadingAnimationWidget.inkDrop(color: AppColors.black, size: 35)
              : Padding(
                  padding: EdgeInsets.only(
                    top: widget.tableHeight * .05,
                    left: widget.tableWidth * .025,
                    right: widget.tableWidth * .025,
                  ),
                  child: SingleChildScrollView(
                    child: DataTable(
                      columnSpacing: 0,
                      horizontalMargin: widget.tableWidth * .025,
                      columns: [
                        DataColumn(label: createTimeLabel('التوقيت')),
                        DataColumn(label: createPatientLabel('المريض')),
                        DataColumn(label: createPlace('مكان العلاج')),
                        DataColumn(label: createPhase('المرحلة')),
                        // DataColumn(label: createText('ملاحظات')),
                        DataColumn(label: createText('العمليات')),
                      ],
                      rows: [
                        ...state.page.appointments!
                            .map((e) => createTableRecord(e))
                            .toList()
                      ],
                    ),
                  ),
                )
          : state is LoadingAppointmentsState
              ? Container(color: Colors.yellow)
              : Container(color: Colors.red),
    );
  }

  createTableRecord(AppointmentModel app) {
    Color rowColor;
    switch (app.type) {
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
        DataCell(createPatientLabel(app.patient!.name!)),
        DataCell(createPlace(app.place!)),
        DataCell(createPhase(app.nextPhase!)),
        // DataCell(createNotes(app.notes!)),
        DataCell(createButtons(app)),
      ],
    );
  }

  createTimeLabel(String date) {
    return SizedBox(
      width: widget.tableWidth * .075,
      child: createText(date),
    );
  }

  createPatientLabel(String patient) {
    return SizedBox(
      width: widget.tableWidth * .2,
      child: createText(patient),
    );
  }

  createPlace(String place) {
    return SizedBox(
      width: widget.tableWidth * .125,
      child: createText(place),
    );
  }

  createPhase(String phase) {
    return SizedBox(
      width: widget.tableWidth * .1,
      child: createText(phase),
    );
  }

  // createNotes(String notes){
  //   return SizedBox(
  //     width: widget.tableWidth * .2,
  //     child: Text(
  //       notes,
  //       overflow: TextOverflow.fade,
  //       style: const TextStyle(
  //         fontFamily: 'Cairo',
  //         fontSize: 14,
  //         color: AppColors.black,
  //       ),
  //     ),
  //   );
  // }

  createButtons(AppointmentModel app) {
    return SizedBox(
      width: widget.tableWidth * .35,
      child: Row(
        children: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NewSession(app: app)));
            },
            minWidth: widget.tableWidth * .1,
            color: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'إدخال',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: widget.tableWidth * .025),
          MaterialButton(
            onPressed: () async {
              await showUpsertAppointment(
                  context: context, ref: ref, type: app.type!, app: app);
            },
            minWidth: widget.tableWidth * .1,
            color: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'تعديل',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(width: widget.tableWidth * .025),
          MaterialButton(
            onPressed: () async {
              await ref
                  .read(appointmentsProvider.notifier)
                  .deleteMaterial(app.id!);
              await ref
                  .read(appointmentsProvider.notifier)
                  .getAllAppointments(ref.read(selectedDate).toString());
            },
            minWidth: widget.tableWidth * .1,
            color: AppColors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'حذف',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
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
