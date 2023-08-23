// ignore_for_file: use_build_context_synchronously

import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/core/customs.dart';
import 'package:clinic_management_system/core/strings/services_types.dart';
import 'package:clinic_management_system/core/strings/teeth.dart';
import 'package:clinic_management_system/features/appointments_sessions/data/models/patient_lab_order.dart';
import 'package:clinic_management_system/features/appointments_sessions/presentation/states/control_states.dart';
import 'package:clinic_management_system/features/lab_feature/data/models/lab_model.dart';
import 'package:clinic_management_system/features/lab_feature/data/models/lab_order.dart';
import 'package:clinic_management_system/features/lab_feature/presentation/rievrpod/lab_provider.dart';
import 'package:clinic_management_system/features/lab_feature/presentation/rievrpod/lab_state.dart';
import 'package:clinic_management_system/features/teeth_model/teeth_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<PatientLabOrderModel?> placeOrder(BuildContext context, WidgetRef ref, int patientId) async {
  await ref.read(labsProvider.notifier).getPaginatedLabs(1000, 1);

  final screenH = MediaQuery.of(context).size.height;
  final height = screenH * .75;
  final screenW = MediaQuery.of(context).size.width;
  final width = screenW * .6;

  PatientLabOrderModel? order = PatientLabOrderModel();

  final labsState = ref.watch(labsProvider);
  Lab? selectedLab;
  LabOrder? selectedService;
  DateTime? createdAt;
  DateTime? deliverAt;
  final createdAtController = TextEditingController();
  final deliverAtController = TextEditingController();
  List<String> selectedTeeth = [];
  String? type = serviceType[0];
  final notes = TextEditingController();
  final degree = TextEditingController();

  Future<DateTime?> selectDate({DateTime? initDate}) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: initDate?? DateTime.now(),
      firstDate: initDate?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      return newDate;
    } else{
      return DateTime.now();
    }
  }

  Future<void> selectTeeth() async {

    final original = selectedTeeth.toList();
    final containerWidth2 = width * .4;
    final containerHeight2 = height * .8;

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
                          'اختر الأسنان',
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
                        child: ListView.builder(
                          itemCount: teeth.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              value: selectedTeeth.contains(teethNotation[index]),
                              onChanged: (value) {
                                setState((){
                                  if (value!) {
                                    selectedTeeth.add(teethNotation[index]);
                                  } else {
                                    selectedTeeth.remove(teethNotation[index]);
                                  }
                                });
                              },
                              title: Text(
                                teethNotation[index],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Cairo',
                                  color: AppColors.black,
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: AppColors.black,
                            );
                          },
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
                              onPressed: () async {
                                Navigator.of(context).pop();
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
                            SizedBox(width: containerWidth2 * .05),
                            MaterialButton(
                              minWidth: containerWidth2 * .3,
                              color: Colors.white,
                              elevation: 0,
                              hoverElevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                selectedTeeth = original;
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

  Future<void> selectType() async {

    String original = type!;
    final containerWidth2 = width * .4;
    final containerHeight2 = height * .7;

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
                          'اختر النوع',
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
                        child: ListView.builder(
                          itemCount: serviceType.length,
                          itemBuilder: (context, index) {
                            return RadioListTile(
                              value: serviceType[index],
                              groupValue: type,
                              onChanged: (value) {
                                setState(() {
                                  type = serviceType[index];
                                });
                              },
                              title: Text(
                                serviceType[index],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Cairo',
                                  color: AppColors.black,
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: AppColors.black,
                            );
                          },
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
                              onPressed: () async {
                                Navigator.of(context).pop();
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
                            SizedBox(width: containerWidth2 * .05),
                            MaterialButton(
                              minWidth: containerWidth2 * .3,
                              color: Colors.white,
                              elevation: 0,
                              hoverElevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                type = original;
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

  await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          child: Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: height * .05, horizontal: width * .05),
              child: SizedBox(
                width: width,
                height: height,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * .1,
                      child: const Text(
                        'طلب مخبر',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 22,
                        ),
                      ),
                    ),
                    SizedBox(height: height * .05),
                    SizedBox(
                      width: width * .9,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                width: width * .4,
                                height: height * .1,
                                child: Stack(
                                  children: [
                                    TextFormField(
                                      enabled: false,
                                      decoration: decorateUpsertField(
                                        width: width * .4,
                                        height: height * .1,
                                        label: 'المخبر',
                                      ),
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 18,
                                      ),
                                    ),
                                    if (labsState is LoadedLabsState)
                                      DropdownButton<Lab>(
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: width * .01,
                                        ),
                                        onChanged: (newLab) {
                                          setState(() {
                                            selectedLab = newLab!;
                                            ref.read(selectedLabId.notifier).state = selectedLab!.id!;
                                            selectedService = null;
                                          });
                                        },
                                        value: selectedLab,
                                        items: labsState.labs.map((t) {
                                          return DropdownMenuItem<Lab>(
                                            alignment: Alignment.centerRight,
                                            value: t,
                                            child: Text(
                                              t.name,
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
                              SizedBox(height: height * 0.05),
                              SizedBox(
                                width: width * .4,
                                height: height * .1,
                                child: Stack(
                                  children: [
                                    TextFormField(
                                      controller: createdAtController,
                                      enabled: false,
                                      decoration: decorateUpsertField(
                                        width: width * .4,
                                        height: height * .1,
                                        label: 'وقت الإرسال',
                                      ),
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 18,
                                      ),
                                    ),
                                    Positioned(
                                      left: width * .005,
                                      // top: height * .0125,
                                      child: SizedBox(
                                        height: height * .075,
                                        child: FloatingActionButton(
                                          onPressed: () async{
                                            createdAt = await selectDate();
                                            setState((){
                                              createdAtController.text = createdAt.toString().substring(0, 10);
                                            });
                                          },
                                          backgroundColor: AppColors.lightGreen,
                                          elevation: 0,
                                          hoverElevation: 0,
                                          focusElevation: 2,
                                          child: const Icon(
                                            Icons.date_range,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: height * 0.05),
                              SizedBox(
                                height: height * .1,
                                width: width * .4,
                                child: MaterialButton(
                                  onPressed: () async{
                                    await selectTeeth();
                                  },
                                  color: AppColors.lightGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'اختر الأسنان',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.05),
                              Container(
                                width: width * .4,
                                height: height * .35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.black45,
                                  ),
                                ),
                                child: TextField(
                                  controller: notes,
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
                            ],
                          ),
                          SizedBox(width: width * .1),
                          Column(
                            children: [
                              SizedBox(
                                width: width * .4,
                                height: height * .1,
                                child: Consumer(
                                  builder: (context, ref, child) {
                                    return Stack(
                                      children: [
                                        TextFormField(
                                          enabled: false,
                                          decoration: decorateUpsertField(
                                            width: width * .4,
                                            height: height * .1,
                                            label: 'الخدمة',
                                          ),
                                          style: const TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 18,
                                          ),
                                        ),
                                        ref.watch(servicesSelect).when(
                                          data: (data) {
                                                final services = data as List<LabOrder>;
                                                return DropdownButton<LabOrder>(
                                                  isExpanded: true,
                                                  underline: const SizedBox(),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: width * .01,
                                                  ),
                                                  onChanged: (newService) async {
                                                    setState(() {
                                                      selectedService = newService!;
                                                    });
                                                  },
                                                  value: selectedService,
                                                  items: services.map((t) {
                                                    return DropdownMenuItem<LabOrder>(
                                                      alignment: Alignment.centerRight,
                                                      value: t,
                                                      child: Text(
                                                        t.name,
                                                        style: const TextStyle(
                                                          fontFamily: 'Cairo',
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                );
                                              },
                                          loading: () => Container(color: Colors.yellow),
                                          error: (error, stackTrace) => Container(color: Colors.red),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: height * 0.05),
                              SizedBox(
                                width: width * .4,
                                height: height * .1,
                                child: Stack(
                                  children: [
                                    TextFormField(
                                      controller: deliverAtController,
                                      enabled: false,
                                      decoration: decorateUpsertField(
                                        width: width * .4,
                                        height: height * .1,
                                        label: 'وقت الاستلام',
                                      ),
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 18,
                                      ),
                                    ),
                                    Positioned(
                                      left: width * .005,
                                      // top: height * .0125,
                                      child: SizedBox(
                                        height: height * .075,
                                        child: FloatingActionButton(
                                          onPressed: () async{
                                            deliverAt = await selectDate(initDate: createdAt);
                                            setState(() {
                                              deliverAtController.text = deliverAt.toString().substring(0, 10);
                                            });
                                          },
                                          backgroundColor: AppColors.lightGreen,
                                          elevation: 0,
                                          hoverElevation: 0,
                                          focusElevation: 2,
                                          child: const Icon(
                                            Icons.date_range,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: height * 0.05),
                              SizedBox(
                                height: height * .1,
                                width: width * .4,
                                child: MaterialButton(
                                  onPressed: () async{
                                    await selectType();
                                  },
                                  color: AppColors.lightGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'اختر النوع',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.05),
                              SizedBox(
                                width: width * .4,
                                height: height * .1,
                                child: TextFormField(
                                  controller: degree,
                                  decoration: decorateUpsertField(
                                    width: width * .4,
                                    height: height * .1,
                                    label: 'الدرجة',
                                  ),
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.025),
                              Container(
                                alignment: Alignment.center,
                                width: width * .4,
                                height: height * .1,
                                child: MaterialButton(
                                  onPressed: (){
                                    order = PatientLabOrderModel(
                                      patientId: patientId,
                                      labId: selectedLab!.id,
                                      serviceId: selectedService!.id,
                                      type: type,
                                      createdAt: createdAtController.text,
                                      deliverAt: deliverAtController.text,
                                      degree: degree.text,
                                      notations: selectedTeeth,
                                      directions: notes.text,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  height: height * .1,
                                  minWidth: width * .2,
                                  color: AppColors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Text(
                                    'حفظ',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: height * 0.025),
                              Container(
                                alignment: Alignment.center,
                                width: width * .4,
                                height: height * .1,
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  height: height * .1,
                                  minWidth: width * .2,
                                  color: AppColors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Text(
                                    'إلغاء',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ));
    },
  );

  return order;
}
