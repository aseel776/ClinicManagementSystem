import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/features/medicine/presentation/widgets/primaryText.dart';
import 'package:clinic_management_system/features/patients_management/data/models/patient.dart';
import 'package:clinic_management_system/features/patients_management/presentation/riverpod/create_patient_provider.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/textField.dart';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../diseases_badHabits/presentation/widgets/tooltip_custom.dart';

StateProvider name =
    StateProvider<TextEditingController>((ref) => TextEditingController());
StateProvider mainComp =
    StateProvider<TextEditingController>((ref) => TextEditingController());
StateProvider phoneNumber =
    StateProvider<TextEditingController>((ref) => TextEditingController());

class Step1Form extends ConsumerWidget {
  double? screenWidth;
  double? screenHeight;

  Step1Form({super.key, this.screenHeight, this.screenWidth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Stack(
        children: [
          Container(
            width: screenWidth! * 0.6,
            height: screenHeight! * 0.52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, AppColors.lightGrey]),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                          width: screenWidth! * 0.24,
                          child: textfield("اسم المريض",
                              ref.watch(name.notifier).state, "fsdf", 1)),
                      Container(
                          width: screenWidth! * 0.24,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                              borderRadius: BorderRadius.circular(15)),
                          child: InternationalPhoneNumberInput(
                              textAlign: TextAlign.start,
                              cursorColor: AppColors.lightGreen,
                              textAlignVertical: TextAlignVertical.top,
                              textFieldController:
                                  ref.watch(phoneNumber.notifier).state,
                              textStyle:
                                  const TextStyle(color: AppColors.black),
                              inputDecoration: const InputDecoration(
                                  hintText: "رقم الهاتف",
                                  hintStyle: TextStyle(height: 0),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none)),
                              searchBoxDecoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(),
                                  enabledBorder: UnderlineInputBorder()),
                              initialValue: PhoneNumber(
                                  isoCode: 'SY', phoneNumber: "+963"),
                              selectorConfig: const SelectorConfig(
                                  selectorType: PhoneInputSelectorType.DIALOG),
                              onInputChanged: (value) {})),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight! * 0.03,
                  ),
                  Container(
                    width: screenWidth! * 0.55,
                    child: SizedBox(
                        width: screenWidth! * 0.44,
                        child: textfield("التشخيص الرئيسي",
                            ref.watch(mainComp.notifier).state, "fsdf", 6)),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //       left: screenWidth! * 0.5, top: screenHeight! * 0.06),
                  //   child: SizedBox(
                  //     width: screenWidth! * 0.075,
                  //     child: ElevatedButton(
                  //         onPressed: () {
                  //           ref.read(currentStep.notifier).state = 1;
                  //         },
                  //         style: const ButtonStyle(
                  //           backgroundColor:
                  //               MaterialStatePropertyAll(AppColors.lightGreen),
                  //           shape: MaterialStatePropertyAll(
                  //               RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.all(
                  //                       Radius.elliptical(10, 70)))),
                  //         ),
                  //         child: Row(
                  //           children: [
                  //             Icon(
                  //               Icons.arrow_back,
                  //               color: AppColors.black,
                  //               size: 17,
                  //             ),
                  //             const PrimaryText(
                  //               text: "التالي",
                  //               size: 16,
                  //               height: 1.7,
                  //               color: AppColors.black,
                  //             ),
                  //           ],
                  //         )),
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 30,
                  //   height: 20,
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       ref.read(currentStep.notifier).state = 1;
                  //     },
                  //     style: const ButtonStyle(
                  //       // maximumSize: MaterialStatePropertyAll(Size(500, 10)),
                  //       backgroundColor:
                  //           MaterialStatePropertyAll(AppColors.lightGreen),
                  //       shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  //           borderRadius:
                  //               BorderRadius.all(Radius.elliptical(10, 70)))),
                  //     ),
                  //     child: const PrimaryText(
                  //       text: "إنشاء الان",
                  //       size: 16,
                  //       height: 1.7,
                  //       color: AppColors.black,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                right: screenWidth! * 0.25, top: screenHeight! * 0.55),
            child: Tooltip(
              message: "إنشاء حساب جديد ب اسم ورقم\n وتشخيص رئيسي فقط",
              padding: EdgeInsets.all(10),
              decoration: ShapeDecoration(
                color: AppColors.black,
                shape: ToolTipCustomShape(),
              ),
              child: ElevatedButton(
                onPressed: () {
                  Patient newPatient = Patient();
                  newPatient.name = ref.watch(name.notifier).state.text;
                  newPatient.mainComplaint =
                      ref.watch(mainComp.notifier).state.text;
                  newPatient.phone = ref.watch(phoneNumber.notifier).state.text;
                  newPatient.gender = "male";
                  // newPatient.address = "barzeh";
                  // newPatient.job = "developer";
                  // newPatient.maritalStatus = "single";
                  // newPatient.patientBadHabits = [
                  //   PatientBadHabits(id: 1, notes: "azooooz")
                  // ];
                  print("phone: " + newPatient.phone!);
                  ref
                      .watch(patientsCrudProvider.notifier)
                      .createNewPatient(newPatient);
                },
                style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(AppColors.lightGreen),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(10, 70)))),
                ),
                child: const PrimaryText(
                  text: "إنشاء الان",
                  size: 16,
                  height: 1.7,
                  color: AppColors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
