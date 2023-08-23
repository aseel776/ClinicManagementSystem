import 'package:clinic_management_system/features/appointments_sessions/data/models/appointment_model.dart';
import 'package:clinic_management_system/features/appointments_sessions/data/models/pres_input_model.dart';
import 'package:clinic_management_system/features/appointments_sessions/data/models/sessionInputModel.dart';
import 'package:clinic_management_system/features/appointments_sessions/presentation/states/patient_treatments/patient_treatments_provider.dart';
import 'package:clinic_management_system/features/appointments_sessions/presentation/states/patient_treatments/patient_treatments_state.dart';
import 'package:clinic_management_system/features/appointments_sessions/presentation/widgets/ongoing_treatment.dart';

import 'package:clinic_management_system/features/appointments_sessions/presentation/widgets/select_treatment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './/core/app_colors.dart';

class NewSession extends ConsumerStatefulWidget {
  final AppointmentModel app;

  const NewSession({
    Key? key,
    required this.app,
  }) : super(key: key);

  @override
  ConsumerState<NewSession> createState() => _NewSessionState();
}

class _NewSessionState extends ConsumerState<NewSession> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref
          .read(patientTreatmentsProvider.notifier)
          .getOngoingTreatments(widget.app.patient!.id!);
    });
  }

  List<SessionInputModel> allWork = [];
  List<PrescriptionInput> pres = [];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(patientTreatmentsProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: screenWidth,
          height: screenHeight,
          color: AppColors.lightGrey,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * .01,
            vertical: screenHeight * .01,
          ),
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * .15,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: screenHeight * .075,
                      child: FloatingActionButton(
                        onPressed: () => Navigator.of(context).pop(),
                        backgroundColor: AppColors.black,
                        heroTag: Object(),
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Column(
                      children: [
                        SizedBox(
                          height: screenHeight * .075,
                          child: const Text(
                            'جلسة جديدة',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 24,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * .075,
                          child: Text(
                            widget.app.patient!.name!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),
              const SizedBox(height: .025),
              SizedBox(
                height: screenHeight * .075,
                width: screenWidth * .8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'تاريخ الجلسة: ${widget.app.time!.toString().substring(0, 10)}',
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 20,
                      ),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        await selectTreatment(
                            context, ref, widget.app.patient!.id!);
                      },
                      color: AppColors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: screenHeight * .075,
                      minWidth: screenWidth * .15,
                      child: const Text(
                        'معالجة جديدة',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: .025),
              SizedBox(
                height: screenHeight * .7525,
                width: screenWidth * .8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'المعالجات الجارية:',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: screenHeight * .025),
                        if (state is LoadedPatientTreatmentsState)
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ...state.treatments.reversed.map(
                                    (e) {
                                      return Column(
                                        children: [
                                          OnGoingTreatment(e, allWork),
                                          SizedBox(height: screenHeight * .025),
                                        ],
                                      );
                                    },
                                  ).toList(),
                                ],
                              ),
                            ),
                          )
                        else if (state is LoadingPatientTreatmentsState)
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.yellow,
                            ),
                          )
                        else
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.red,
                            ),
                          )
                      ],
                    ),
                    Column(
                      children: [
                        const Expanded(child: SizedBox()),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () async {
                                // pres = await createPres(context, ref);
                              },
                              color: AppColors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: screenHeight * .075,
                              minWidth: screenWidth * .15,
                              child: const Text(
                                'تصدير وصفة',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * .025),
                            MaterialButton(
                              onPressed: () {
                                //open pop up
                              },
                              color: AppColors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: screenHeight * .075,
                              minWidth: screenWidth * .15,
                              child: const Text(
                                'طلب مخبر',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * .025),
                            MaterialButton(
                              onPressed: () {
                                //open pop up
                              },
                              color: AppColors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: screenHeight * .075,
                              minWidth: screenWidth * .15,
                              child: const Text(
                                'إضافة تشخيص',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * .025),
                            MaterialButton(
                              onPressed: () {
                                //open pop up
                              },
                              color: AppColors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: screenHeight * .075,
                              minWidth: screenWidth * .15,
                              child: const Text(
                                'إضافة دفعة',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Expanded(child: SizedBox()),
                        MaterialButton(
                          onPressed: () {
                            //call create session
                          },
                          color: AppColors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: screenHeight * .075,
                          minWidth: screenWidth * .15,
                          child: const Text(
                            'حفظ',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * .025),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
