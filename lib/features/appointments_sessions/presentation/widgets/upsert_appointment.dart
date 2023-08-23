import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/core/customs.dart';
import 'package:clinic_management_system/features/appointments_sessions/data/models/appointment_model.dart';
import 'package:clinic_management_system/features/appointments_sessions/presentation/states/appointment/appointment_provider.dart';
import 'package:clinic_management_system/features/appointments_sessions/presentation/states/appointments/appointments_provider.dart';
import 'package:clinic_management_system/features/appointments_sessions/presentation/states/control_states.dart';
import 'package:clinic_management_system/features/appointments_sessions/presentation/states/patient_treatments/patient_treatments_provider.dart';
import 'package:clinic_management_system/features/appointments_sessions/presentation/states/patient_treatments/patient_treatments_state.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient.dart';
import 'package:clinic_management_system/features/patients_management/presentation/riverpod/patients_provider.dart';
import 'package:clinic_management_system/features/patients_management/presentation/riverpod/patients_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showUpsertAppointment(
    {required BuildContext context,
    required WidgetRef ref,
    required String type,
    AppointmentModel? app}) async {

  ref.read(patientsProvider.notifier).getPaginatedPatients(100000, 1);
  final screenWidth = MediaQuery.of(context).size.width;
  final containerWidth = screenWidth * .6;
  final screenHeight = MediaQuery.of(context).size.height;
  final containerHeight = screenHeight * .75;

  final date = ValueNotifier(ref.read(selectedDate));
  final time= ValueNotifier(DateTime.now().toString().substring(11, 16));
  final patientName = ValueNotifier('');
  int? patientId;
  final notesController = TextEditingController();
  final ongoingTreatments = ref.watch(patientTreatmentsProvider);

  if(app != null){
    date.value = app.time!;
    time.value = app.time.toString().substring(11, 16);
    patientName.value = app.patient!.name!;
    patientId = app.patient!.id;
    ref.read(patientTreatmentsProvider.notifier).getOngoingTreatments(patientId!);
    notesController.text = app.notes?? '';
  }


  Future<DateTime?> selectAppDate() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: date.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    final oldDate = date.value;
    if (newDate != null && newDate != oldDate) {
      return newDate;
    } else {
      return oldDate;
    }
  }

  Future<String> selectAppTime() async {
    int initHour = int.parse(time.value.substring(0,2));
    int initMin = int.parse(time.value.substring(3,5));
    TimeOfDay oldTime = TimeOfDay(hour: initHour, minute: initMin);
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: oldTime,

    );

    if (pickedTime != null && pickedTime != oldTime) {
      return pickedTime.toString().substring(10, 15);
    }else{
      return oldTime.toString().substring(10, 15);
    }
  }

  Future<void> selectPatient() async{
    final state = ref.watch(patientsProvider);
    final oldName = patientName.value;
    final oldId = patientId;
    final containerWidth2 = containerWidth * .4;
    final containerHeight2 = containerHeight * .8;

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  width: containerWidth2,
                  height: containerHeight2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.only(
                    top: containerHeight2 * .035,
                    bottom: containerHeight2 * .025,
                    left: containerWidth2 * .05,
                    right: containerWidth2 * .05,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: containerHeight2 * .1,
                        child: const Text(
                          'اختر المريض',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 20,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: containerHeight2 * .025,
                        child: Divider(
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(height: containerHeight2 * .02),
                      SizedBox(
                        height: containerHeight2 * .655,
                        child: state is LoadedPatientsState
                            ? ListView.builder(
                          itemCount: state.patients.length,
                          itemBuilder: (context, index) {
                            return RadioListTile(
                              value: state.patients[index].id,
                              groupValue: patientId,
                              onChanged: (value) {
                                patientName.value = state.patients[index].name!;
                                setState(() {
                                  patientId = value;
                                });
                              },
                              title: Text(
                                state.patients[index].name!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Cairo',
                                  color: AppColors.black,
                                ),
                              ),
                              controlAffinity:
                              ListTileControlAffinity.leading,
                              activeColor: AppColors.black,
                            );
                          },
                        )
                            : const Center(
                          child: Text(
                            'لا يوجد مرضى بعد',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: containerHeight2 * .04),
                      SizedBox(
                        height: containerHeight2 * .1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              minWidth: containerWidth2 * .3,
                              color: Colors.white,
                              elevation: 0,
                              hoverElevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              onPressed: () async{
                                Navigator.of(context).pop();
                                await ref.read(patientTreatmentsProvider.notifier).getOngoingTreatments(patientId!);
                              },
                              child: const Text(
                                'تأكيد',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: containerWidth * .05),
                            MaterialButton(
                              minWidth: containerWidth2 * .3,
                              color: Colors.white,
                              elevation: 0,
                              hoverElevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              onPressed: () {
                                patientName.value = oldName;
                                patientId = oldId;
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'إلغاء',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  DateTime formDate(){
    return DateTime(
      date.value.year,
      date.value.month,
      date.value.day,
      int.parse(time.value.substring(0, 2)),
      int.parse(time.value.substring(3, 5)),
    );
  }

  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                width: containerWidth,
                height: containerHeight,
                padding: EdgeInsets.symmetric(
                  horizontal: containerWidth * .05,
                  vertical: containerHeight * .05,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: containerHeight * .15,
                      child: Text(
                        (app == null)
                            ? 'إضافة موعد'
                        : 'تعديل',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 22
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //date
                            SizedBox(
                              width: containerWidth * .4,
                              height: containerHeight * .075,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: containerWidth * .05,
                                    child: FloatingActionButton(
                                      backgroundColor: AppColors.lightGreen,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)
                                      ),
                                      onPressed: () async{
                                        date.value = (await selectAppDate())!;
                                      },
                                      child: const Icon(
                                        Icons.date_range,
                                        color: Colors.black,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: containerWidth * .01),
                                  ValueListenableBuilder(
                                    valueListenable: date,
                                    builder: (context, value, child) {
                                      return Expanded(
                                        child: Text(
                                          'التاريخ: ${value
                                              .toString()
                                              .substring(0, 10)}',
                                          style: const TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 18,
                                          ),
                                          overflow: TextOverflow.fade,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: containerHeight * .05),
                            //time
                            SizedBox(
                              width: containerWidth * .4,
                              height: containerHeight * .075,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: containerWidth * .05,
                                    child: FloatingActionButton(
                                      backgroundColor: AppColors.lightGreen,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      onPressed: () async{
                                        time.value = await selectAppTime();
                                      },
                                      child: const Icon(
                                        Icons.access_time_filled,
                                        color: Colors.black,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: containerWidth * .01),
                                  ValueListenableBuilder(
                                    valueListenable: time,
                                    builder: (context, value, child) {
                                      return Expanded(
                                        child: Text(
                                          'الوقت: $value',
                                          style: const TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 18,
                                          ),
                                          overflow: TextOverflow.fade,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: containerHeight * .05),
                            //patient
                            SizedBox(
                              width: containerWidth * .4,
                              height: containerHeight * .075,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: containerWidth * .05,
                                    child: FloatingActionButton(
                                      backgroundColor: AppColors.lightGreen,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      onPressed: () async{
                                        await selectPatient();
                                      },
                                      child: const Icon(
                                        Icons.face_sharp,
                                        color: Colors.black,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: containerWidth * .01),
                                  ValueListenableBuilder(
                                    valueListenable: patientName,
                                    builder: (context, value, child) {
                                      return Expanded(
                                        child: Text(
                                          'المريض: $value',
                                          style: const TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 18,
                                          ),
                                          overflow: TextOverflow.fade,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: containerHeight * .05),
                            //notes
                            SizedBox(
                              width: containerWidth * .4,
                              height: containerHeight * .25,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: containerWidth * .05,
                                    height: containerHeight * .075,
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGreen,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Icon(
                                      Icons.note_alt,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(width: containerWidth * .01),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                      height: containerHeight * .075,
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'ملاحظات:',
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                      Expanded(
                                        child: Container(
                                          width: containerWidth * .34,
                                          decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: TextField(
                                            controller: notesController,
                                            cursorColor: AppColors.black,
                                            expands: true,
                                            maxLines: null,
                                            minLines: null,
                                            decoration: notesDecoration,
                                            style: const TextStyle(
                                              fontFamily: 'Cairo',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: containerWidth * .1),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //title
                            SizedBox(
                              width: containerWidth * .4,
                              height: containerHeight * .075,
                              child: Row(
                                children: [
                                  Container(
                                    width: containerWidth * .05,
                                    height: containerHeight * .075,
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGreen,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Icon(
                                      Icons.next_plan,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(width: containerWidth * .01),
                                  const Expanded(
                                    child: Text(
                                      'الخطوة التالية:',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: containerHeight * .05),
                            Container(
                              width: containerWidth * .4,
                              height: containerHeight * .4,
                              alignment: Alignment.center,
                              child: (ongoingTreatments is LoadedPatientTreatmentsState && ongoingTreatments.treatments.isNotEmpty)
                                  ? Container(color: Colors.red)
                                  : const Text(
                                'لا يوجد معالجات جارية حالياً',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: containerHeight * .05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () async{
                            final newApp = AppointmentModel(
                              time: formDate(),
                              type: type,
                              patient: Patient(id: patientId, name: patientName.value),
                              place: '',
                              nextPhase: '',
                              notes: notesController.text,
                            );
                            ref.read(selectedDate.notifier).state = formDate();
                            Navigator.of(context).pop();
                            if(app == null){
                              await ref.read(appointmentsProvider.notifier).createAppointment(newApp);
                            } else{
                              newApp.id = app.id;
                              await ref.read(appointmentProvider.notifier).updateAppointment(newApp);
                            }
                            await ref.read(appointmentsProvider.notifier).getAllAppointments(formDate().toString());
                          },
                          height: containerHeight * .075,
                          minWidth: containerWidth * .15,
                          color: AppColors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'حفظ',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(width: containerWidth * .05),
                        MaterialButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          height: containerHeight * .075,
                          minWidth: containerWidth * .15,
                          color: AppColors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'إلغاء',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
