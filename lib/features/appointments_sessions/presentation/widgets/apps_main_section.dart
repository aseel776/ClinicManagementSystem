import 'package:clinic_management_system/core/primaryText.dart';
import 'package:clinic_management_system/features/appointments_sessions/data/models/appointment_model.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient.dart';
import 'package:clinic_management_system/sidebar/presentation/pages/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../states/reservations/reservations_provider.dart';
import '../states/reservations/reservations_state.dart';
import './appointments_table.dart';
import './upsert_appointment.dart';
import '../states/control_states.dart';
import '../states/appointments/appointments_provider.dart';
import './/core/app_colors.dart';

class AppointmentsMainSection extends StatelessWidget {
  const AppointmentsMainSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width * .83;
    final screenHeight = MediaQuery.of(context).size.height * .93;

    return Scaffold(
        body: Container(
      // width: screenWidth,
      height: screenHeight,
      color: AppColors.lightGrey,
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * .1,
            child: const Text(
              'قسم المواعيد',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 24,
                color: AppColors.black,
              ),
            ),
          ),
          SizedBox(
            width: screenWidth * .4,
            height: screenHeight * .05,
            child: Consumer(
              builder: (_, ref, __) {
                final displayedDate = ref.watch(selectedDate);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screenHeight * .05,
                      width: screenWidth * .1,
                      child: Tooltip(
                        message: 'السابق',
                        textStyle: const TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                        ),
                        child: FloatingActionButton(
                          heroTag: Object(),
                          onPressed: () async {
                            ref.read(selectedDate.notifier).state =
                                displayedDate.subtract(const Duration(days: 1));
                            ref
                                .read(appointmentsProvider.notifier)
                                .getAllAppointments(
                                    ref.read(selectedDate).toString());
                          },
                          backgroundColor: AppColors.black,
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * .005),
                    SizedBox(
                      width: screenWidth * .125,
                      height: screenHeight * .05,
                      child: InkWell(
                        onTap: () async {
                          await selectDate(context, ref);
                        },
                        child: Text(
                          displayedDate.toString(),
                          style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 22,
                              color: AppColors.black),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * .005),
                    SizedBox(
                      height: screenHeight * .05,
                      width: screenWidth * .1,
                      child: Tooltip(
                        message: 'التالي',
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                        ),
                        child: FloatingActionButton(
                          heroTag: Object(),
                          onPressed: () async {
                            ref.read(selectedDate.notifier).state =
                                displayedDate.add(const Duration(days: 1));
                            ref
                                .read(appointmentsProvider.notifier)
                                .getAllAppointments(
                                    ref.read(selectedDate).toString());
                          },
                          backgroundColor: AppColors.black,
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            height: screenHeight * .85,
            child: Row(
              children: [
                AppointmentsTable(
                  tableHeight: screenHeight * .85,
                  tableWidth: screenWidth * .85,
                ),
                SizedBox(
                  width: screenWidth * .025 / 2,
                ),
                SizedBox(
                    width: screenWidth * .125,
                    child: Consumer(
                      builder: (context, ref, child) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: screenWidth * .125,
                            child: MaterialButton(
                              onPressed: () async {
                                await showUpsertAppointment(
                                  context: context,
                                  ref: ref,
                                  type: 'normal',
                                );
                              },
                              color: AppColors.black,
                              minWidth: screenWidth * .125,
                              height: screenHeight * .075,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'إضافة موعد',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Cairo'),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * .025),
                          SizedBox(
                            width: screenWidth * .125,
                            child: MaterialButton(
                              onPressed: () async {
                                await showUpsertAppointment(
                                  context: context,
                                  ref: ref,
                                  type: 'waiting',
                                );
                              },
                              color: AppColors.black,
                              minWidth: screenWidth * .125,
                              height: screenHeight * .075,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'إدخال من الانتظار',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Cairo',
                                ),
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * .025),
                          SizedBox(
                            width: screenWidth * .125,
                            child: MaterialButton(
                              onPressed: () async {
                                await showUpsertAppointment(
                                  context: context,
                                  ref: ref,
                                  type: 'emergency',
                                );
                              },
                              color: AppColors.black,
                              minWidth: screenWidth * .125,
                              height: screenHeight * .075,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'إدخال إسعافي',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Cairo',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * .025),
                          SizedBox(
                            width: screenWidth * .125,
                            child: MaterialButton(
                              onPressed: () async {
                                await ref
                                    .watch(reservationsProvider.notifier)
                                    .getAllReservations();
                                _showReservationListPopup(context, ref);
                              },
                              color: AppColors.black,
                              minWidth: screenWidth * .125,
                              height: screenHeight * .075,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'المواعيد الخارجية',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Cairo'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                SizedBox(
                  width: screenWidth * .025 / 2,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  void _showReservationListPopup(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('المواعيد الخارجية'),
          content: Consumer(builder: (context, watch, child) {
            final state = ref.watch(reservationsProvider.notifier).state;

            if (state is LoadedReservationsState) {
              final reservations = state.reservations;

              if (reservations.isEmpty) {
                return Text('No reservations available.');
              }

              return SingleChildScrollView(
                child: Column(
                  children: reservations.map((reservation) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(reservation.date),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(reservation.notes),
                              SizedBox(height: 4),
                              Text(
                                  'Patient: ${reservation.patient.name}'), // Display patient name or any relevant data
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            MaterialButton(
                              onPressed: () async {
                                await ref
                                    .read(reservationsProvider.notifier)
                                    .deleteReservation(reservation.id)
                                    .then((value) {
                                  ref
                                      .watch(reservationsProvider.notifier)
                                      .getAllReservations();
                                  Navigator.pop(context);
                                });
                                // Refresh the list after deletion if needed
                              },
                              child: Text(
                                "رفض",
                                style: TextStyle(
                                  color: Colors.red,
                                  // Adjust styling as needed
                                ),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () async {
                                await showUpsertAppointment(
                                    context: context,
                                    ref: ref,
                                    app: AppointmentModel(
                                        reserveId: reservation.id,
                                        time: DateTime.parse(reservation.date),
                                        patient: Patient(
                                            name: reservation.patient.name,
                                            id: reservation.patientId)),
                                    type: 'external');
                                // Refresh the list after deletion if needed
                              },
                              child: Text(
                                "قبول ",
                                style: TextStyle(
                                  color: Colors.red,
                                  // Adjust styling as needed
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    );
                  }).toList(),
                ),
              );
            } else if (state is ErrorReservationsState) {
              return Text(state.message);
            } else {
              return CircularProgressIndicator();
            }
          }),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> selectDate(BuildContext context, WidgetRef ref) async {
    final date = await showDatePicker(
      context: context,
      initialDate: ref.read(selectedDate),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    final oldDate = ref.read(selectedDate);
    if (date != null && date != oldDate) {
      ref.read(selectedDate.notifier).state = date;
      ref
          .read(appointmentsProvider.notifier)
          .getAllAppointments(date.toString());
    }
  }
}
