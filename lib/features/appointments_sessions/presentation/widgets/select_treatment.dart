// ignore_for_file: use_build_context_synchronously

import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/core/customs.dart';
import 'package:clinic_management_system/core/strings/teeth.dart';
import 'package:clinic_management_system/features/appointments_sessions/data/models/patient_treatment_model.dart';
import 'package:clinic_management_system/features/appointments_sessions/presentation/states/patient_treatments/patient_treatments_provider.dart';
import 'package:clinic_management_system/features/appointments_sessions/presentation/states/patient_treatments/patient_treatments_state.dart';
import 'package:clinic_management_system/features/treatments_feature/data/models/treatment_model.dart';
import 'package:clinic_management_system/features/treatments_feature/presentation/states/treatments/treatments_provider.dart';
import 'package:clinic_management_system/features/treatments_feature/presentation/states/treatments/treatments_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> selectTreatment(BuildContext context, WidgetRef ref, int patientId) async{

  await ref.read(treatmentsProvider.notifier).getAllTreatments(page: 1, items: 100000);

  final width = MediaQuery.of(context).size.width;
  final containerWidth = width * .3;
  final height = MediaQuery.of(context).size.height;
  final containerHeight = height * .6;

  TreatmentModel? selectedTreatment;
  final placeController = TextEditingController(text: 'TH.11');
  final priceConroller = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) {
      final typesState = ref.watch(treatmentsProvider);
      return Dialog(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                width: containerWidth,
                height: containerHeight,
                decoration: const BoxDecoration(
                  color: AppColors.lightGreen,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: containerHeight * .05,
                  horizontal: containerWidth * .025,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: containerHeight * .075,
                      child: const Text(
                        'أضف معالجة جديدة',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(height: containerHeight * .1),
                    SizedBox(
                      width: containerWidth * .8,
                      height: containerHeight * .1,
                      child: Stack(
                        children: [
                          TextFormField(
                            decoration: decorateUpsertField(
                              width: containerWidth * .3,
                              height: containerHeight * .125,
                              label: 'المعالجة',
                            ),
                          ),
                          if (typesState is LoadedTreatmentsState)
                            DropdownButton<TreatmentModel>(
                              isExpanded: true,
                              padding: EdgeInsets.symmetric(
                                horizontal: containerWidth * .01,
                              ),
                              onChanged: (newTreatment) {
                                setState(() {
                                  selectedTreatment = newTreatment!;
                                });
                              },
                              value: selectedTreatment,
                              items: typesState.page.treatments!.map((t) {
                                return DropdownMenuItem<TreatmentModel>(
                                  alignment: Alignment.centerRight,
                                  value: t,
                                  child: Text(
                                    t.name!,
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: containerHeight * .1),
                    SizedBox(
                      width: containerWidth * .8,
                      height: containerHeight * .1,
                      child: Stack(
                        children: [
                          TextFormField(
                            decoration: decorateUpsertField(
                              width: containerWidth * .3,
                              height: containerHeight * .125,
                              label: 'مكان المعالجة',
                            ),
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                            ),
                            controller: placeController,
                          ),
                            DropdownButton<String>(
                              isExpanded: true,
                              padding: EdgeInsets.symmetric(
                                horizontal: containerWidth * .01,
                              ),
                              onChanged: (place) {
                                setState(() {
                                  placeController.text = place!;
                                });
                              },
                              value: placeController.text,
                              items: teethNotation.map((t) {
                                return DropdownMenuItem<String>(
                                  alignment: Alignment.centerRight,
                                  value: t,
                                  child: Text(
                                    t,
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: containerHeight * .1),
                    SizedBox(
                      height: containerHeight * .1,
                      width: containerWidth * .8,
                      child: TextFormField(
                        decoration: decorateUpsertField(
                          width: containerWidth * .3,
                          height: containerHeight * .125,
                          label: 'السعر',
                        ),
                        controller: priceConroller,
                      ),
                    ),
                    SizedBox(height: containerHeight * .1),
                    MaterialButton(
                      onPressed: () async{
                        Navigator.of(context).pop();
                        final temp = PatientTreatmentModel(
                          patientId: patientId,
                          place: placeController.text,
                          price: int.parse(priceConroller.text),
                          treatment: selectedTreatment
                        );
                        await ref.read(patientTreatmentsProvider.notifier).createPatientTreatment(temp);
                        if(ref.read(patientTreatmentsProvider) is SuccessPatientTreatmentsState){
                          await ref.read(patientTreatmentsProvider.notifier).getOngoingTreatments(patientId);
                        }
                      },
                      height: containerHeight * .1,
                      minWidth: containerWidth * .4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: AppColors.black,
                      child: const Text(
                        'إضافة',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white,
                          fontSize: 16,
                        ),
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