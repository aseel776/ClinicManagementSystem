import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/features/medicine/presentation/widgets/primaryText.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/radio_button.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../pages/patients.dart';

StateProvider genderSelect = StateProvider((ref) => "");
StateProvider birthDate = StateProvider<DateTime>((ref) => DateTime(2000));
StateProvider birthDateInString = StateProvider((ref) => "");
StateProvider job =
    StateProvider<TextEditingController>((ref) => TextEditingController());
StateProvider address =
    StateProvider<TextEditingController>((ref) => TextEditingController());

enum MaritalStatus { single, married, divorced, widowed }

String getMaritalStatusText(MaritalStatus status) {
  switch (status) {
    case MaritalStatus.single:
      return 'Single';
    case MaritalStatus.married:
      return 'Married';
    case MaritalStatus.divorced:
      return 'Divorced';
    case MaritalStatus.widowed:
      return 'Widowed';
    default:
      return '';
  }
}

final maritalStatusProvider = StateProvider<MaritalStatus?>((ref) => null);

class Step2Form extends ConsumerWidget {
  List<String> gender = ["male", "female"];

  double? screenWidth;
  double? screenHeight;
  Step2Form({super.key, this.screenHeight, this.screenWidth});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Container(
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
                  Container(
                    width: screenWidth! * 0.2,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: DropdownButton<MaritalStatus>(
                        hint: const PrimaryText(
                          text: "الحالة الاجتماعية",
                        ),
                        elevation: 4,
                        underline: Container(),
                        value: ref.watch(maritalStatusProvider),
                        onChanged: (newValue) {
                          ref.read(maritalStatusProvider.notifier).state =
                              newValue!;
                        },
                        items: MaritalStatus.values.map((status) {
                          return DropdownMenuItem<MaritalStatus>(
                            value: status,
                            child: Text(getMaritalStatusText(status)),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                      width: screenWidth! * 0.24,
                      child: textfield(
                          "العمل", ref.watch(job.notifier).state, "fsdf", 1)),
                ],
              ),
              SizedBox(
                height: screenHeight! * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 0.0),
                    child: Container(
                      height: screenHeight! * 0.075,
                      width: screenWidth! * 0.2,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                              child: const Row(children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.black26,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                PrimaryText(
                                  text: "تاريخ الولادة",
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                ),
                              ]),
                              onTap: () async {
                                final datePick = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime(2000),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));
                                if (datePick != null && datePick != birthDate) {
                                  ref.read(birthDate.notifier).state = datePick;
                                  // isDateSelected=true;

                                  // put it here
                                  ref.read(birthDateInString.notifier).state =
                                      DateFormat("yyyy-MM-dd").format(
                                          ref.watch(birthDate.notifier).state!);

                                  // 08/14/2019
                                  // print(birthDateInString);
                                  print(ref.watch(birthDateInString));
                                }
                              }),
                          const SizedBox(
                            width: 40,
                          ),
                          ref.watch(birthDateInString) == null
                              ? const Text("DD/MM/YYYY")
                              : Text("${ref.watch(birthDateInString)}")
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      width: screenWidth! * 0.24,
                      child: textfield("العنوان",
                          ref.watch(address.notifier).state, "fsdf", 1)),
                ],
              ),
              SizedBox(
                height: screenHeight! * 0.07,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(right: screenHeight! * 0.3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const PrimaryText(
                        text: "جنس المريض :",
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          addRadioButton(0, 'male', gender, ref, genderSelect),
                          const SizedBox(
                            width: 30,
                          ),
                          addRadioButton(
                              1, 'female', gender, ref, genderSelect),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(
              //       left: screenWidth! * 0.02,
              //       right: screenWidth! * 0.02,
              //       top: screenHeight! * 0.07),
              //   child: Row(
              //     children: [
              //       SizedBox(
              //         width: screenWidth! * 0.075,
              //         child: ElevatedButton(
              //             onPressed: () {
              //               ref.read(currentStep.notifier).state = 2;
              //             },
              //             style: const ButtonStyle(
              //               backgroundColor:
              //                   MaterialStatePropertyAll(AppColors.lightGreen),
              //               shape: MaterialStatePropertyAll(
              //                   RoundedRectangleBorder(
              //                       borderRadius: BorderRadius.all(
              //                           Radius.elliptical(10, 70)))),
              //             ),
              //             child: Row(
              //               children: [
              //                 Icon(
              //                   Icons.arrow_back,
              //                   color: AppColors.black,
              //                   size: 17,
              //                 ),
              //                 Spacer(),
              //                 const PrimaryText(
              //                   text: "التالي",
              //                   size: 16,
              //                   height: 1.7,
              //                   color: AppColors.black,
              //                 ),
              //               ],
              //             )),
              //       ),
              //       Spacer(),
              //       SizedBox(
              //         width: screenWidth! * 0.08,
              //         child: ElevatedButton(
              //             onPressed: () {
              //               ref.read(currentStep.notifier).state = 0;
              //             },
              //             style: const ButtonStyle(
              //               backgroundColor:
              //                   MaterialStatePropertyAll(AppColors.lightGreen),
              //               shape: MaterialStatePropertyAll(
              //                   RoundedRectangleBorder(
              //                       borderRadius: BorderRadius.all(
              //                           Radius.elliptical(10, 70)))),
              //             ),
              //             child: Row(
              //               children: [
              //                 const PrimaryText(
              //                   text: "السابق",
              //                   size: 16,
              //                   height: 1.7,
              //                   color: AppColors.black,
              //                 ),
              //                 Spacer(),
              //                 Icon(
              //                   Icons.arrow_forward,
              //                   color: AppColors.black,
              //                   size: 17,
              //                 ),
              //               ],
              //             )),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
