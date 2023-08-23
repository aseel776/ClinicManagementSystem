import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/features/medicine/presentation/widgets/primaryText.dart';
import 'package:clinic_management_system/features/patients_management/presentation/pages/patients_index.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/custom_stepper.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/step2_form.dart';
import 'package:clinic_management_system/features/patients_management/presentation/widgets/step3_form.dart';
import 'package:clinic_management_system/sidebar/presentation/pages/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/step1_form.dart';

StateProvider stepperWidgets = StateProvider<List<Widget>>((ref) => [
      const Text("1"),
      const Text("2"),
      const Text("3"),
    ]);

StateProvider currentStep = StateProvider((ref) => 0);

class CreatePatients extends ConsumerWidget {
  double? screenHeight;
  double? screenWidth;
  CreatePatients({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Align(
        alignment: Alignment.topRight,
        child: Column(
          children: [
            //banner
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: screenHeight! * 0.07),
                  child: TextButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      onPressed: () {
                        ref.watch(pageProvider.notifier).state =
                            const PatientIndex();
                      },
                      child: const Icon(
                        Icons.arrow_back_outlined,
                        color: AppColors.black,
                      )),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30.0, right: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText(
                        text: "إنشاء حساب مريض ",
                        size: 23,
                        fontWeight: FontWeight.bold,
                      ),
                      PrimaryText(
                        text: "إضافة استمارة مريض جديد إلى العيادة",
                        size: 14,
                        fontWeight: FontWeight.w200,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: screenWidth! * 0.35,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: SizedBox(
                      width: 200,
                      height: 150,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.diagonal3Values(-1, 1, 1),
                        child: SvgPicture.asset(
                          "assets/svgs/patient_form.svg",
                          alignment: Alignment.bottomRight,
                        ),
                      )),
                )
              ],
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Container(
                    height: screenHeight! * 0.58,
                    width: screenWidth! * 0.17,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)),
                    child: BaseStepper(
                      activeStep: ref.watch(currentStep.notifier).state,
                      children: ref.watch(stepperWidgets.notifier).state,
                      onStepReached: (index) {
                        ref.read(currentStep.notifier).state = index;
                      },
                      title: const [
                        PrimaryText(
                          text: "معلومات رئيسية\n والتشخيص",
                        ),
                        PrimaryText(
                          text: "معلومات عامة ",
                        ),
                        PrimaryText(
                          text: "السجل الصحي",
                        ),
                      ],
                      subTitle: const [
                        Text(""),
                        Text(""),
                        Text(""),
                      ],
                      nextPreviousButtonsDisabled: false,
                      direction: Axis.vertical,
                      lineDotRadius: 1,
                      stepColor: Colors.grey,
                      lineColor: AppColors.black,
                      activeStepColor: AppColors.lightGreen,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                ref.watch(currentStep) == 0
                    ? Step1Form(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                      )
                    : ref.watch(currentStep) == 1
                        ? Step2Form(
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                          )
                        : Step3Form(
                            screenHeight: screenHeight,
                            screenWidth: screenWidth,
                          ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
