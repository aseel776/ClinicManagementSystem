// ignore_for_file: use_build_context_synchronously

import 'package:clinic_management_system/core/app_colors.dart';
import 'package:clinic_management_system/core/customs.dart';
import 'package:clinic_management_system/features/appointments_sessions/data/models/pres_input_model.dart';
import 'package:clinic_management_system/features/appointments_sessions/presentation/states/pres/pres_provider.dart';
import 'package:clinic_management_system/features/appointments_sessions/presentation/states/pres/pres_state.dart';
import 'package:clinic_management_system/features/medicine/data/model/medicine_model.dart';
import 'package:clinic_management_system/features/medicine/presentation/riverpod/medicines/medicines_provider.dart';
import 'package:clinic_management_system/features/medicine/presentation/riverpod/medicines/medicines_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<List<PrescriptionInput>> createPres(BuildContext context, WidgetRef ref, int patientId) async{

  final screenWidth = MediaQuery.of(context).size.width;
  final width = screenWidth * .9;
  final screenHeight = MediaQuery.of(context).size.height;
  final height = screenHeight * .8;
  List<PrescriptionInput> meds = [];

    createText(String input){
    return Text(
      input,
      overflow: TextOverflow.fade,
      style: const TextStyle(
        fontSize: 18,
        fontFamily: 'Cairo',
      ),
    );
  }
    createLabel(String input) {
    return SizedBox(
      width: width * .1,
      child: createText(input),
    );
  }
    createRepeat(String input){
      return SizedBox(
        width: width * .15,
        child: createText(input),
      );
    }
    createIns(String input){
      return SizedBox(
        width: width * .25,
        child: createText(input),
      );
    }
    createButtons(PrescriptionInput input, void Function(void Function()) setState){
      return SizedBox(
        width: width * .1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () async{
                PrescriptionInput? tempMed = await selectMed(context, ref, oldMed: input);
                if(tempMed != null){
                  setState(() {
                    meds.remove(input);
                    meds.add(tempMed);
                  },);
              }
            },
              icon: const Icon(
                Icons.edit,
                color: Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () {
                setState((){
                  meds.remove(input);
                });
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      );
    }
    createRow(PrescriptionInput input, void Function(void Function()) setState){
      return DataRow(
        cells:[
          DataCell(createLabel(input.medicineName!)),
          DataCell(createLabel(input.concentration.toString())),
          DataCell(createLabel(input.form!)),
          DataCell(createLabel(input.quantity!)),
          DataCell(createRepeat(input.repeat!)),
          DataCell(createIns(input.desc!)),
          DataCell(createButtons(input, setState)),
        ]
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
                width: width,
                height: height,
                padding: EdgeInsets.symmetric(
                  horizontal: width * .05,
                  vertical: height * .075,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * .1,
                      child: const Text(
                        'الأدوية الموصوفة',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                          child: DataTable(
                            horizontalMargin: 0,
                            columnSpacing: 0,
                            columns: [
                              DataColumn(label: createLabel('الدواء')),
                              DataColumn(label: createLabel('التركيز')),
                              DataColumn(label: createLabel('الشكل')),
                              DataColumn(label: createLabel('الكمية')),
                              DataColumn(label: createRepeat('التكرار')),
                              DataColumn(label: createIns('التعليمات')),
                              DataColumn(label: createLabel('العمليات')),
                            ],
                            rows: [
                              ...meds.map((e) => createRow(e, setState)).toList()
                            ],
                          ),
                        ),
                    ),
                    SizedBox(
                        height: height * .1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                              color: AppColors.black,
                              child: const Text(
                                'حفظ',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(width: width * .025),
                            MaterialButton(
                              onPressed: () async {
                                final temp = await selectMed(context, ref);
                                if (temp != null) {
                                  setState(() {
                                    meds.add(temp);
                                  },);
                                }
                              },
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
                            SizedBox(width: width * .025),
                            MaterialButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                meds.clear();
                              },
                              color: AppColors.black,
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
                    ),
                    SizedBox(height: height * .025),
                    MaterialButton(
                      height: height * .1,
                      minWidth: width * .2,
                      onPressed: () async{
                        if (meds.isNotEmpty){
                          List<int> medsIds = meds.map((e) => e.medicineId!).toList();
                          await ref.read(presProvider.notifier).getConflicts(medsIds, patientId);
                          showConflicts(context, ref);
                        }
                      },
                      color: AppColors.lightGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text(
                        'تحقق من التعارضات',
                        style: TextStyle(
                          fontFamily: 'Cairo',
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
  
  return meds;
}



Future<PrescriptionInput?> selectMed(BuildContext context, WidgetRef ref, {PrescriptionInput? oldMed}) async{

  await ref.read(medicinesProvider.notifier).getPaginatedMedicines(100000, 1);

  final med = PrescriptionInput(
    desc: '',
    quantity: '',
    repeat: '',
  );
  Medicine? selectedMed;
  bool returnFlag = true;

  if(oldMed != null){
    med.medicineId = oldMed.medicineId;
    med.medicineName = oldMed.medicineName;
    med.desc = oldMed.desc;
    med.quantity = oldMed.quantity;
    med.repeat = oldMed.repeat;
    med.concentration = oldMed.concentration;
    med.form = oldMed.form;
  }

  final meds = ref.watch(medicinesProvider);

  final screenWidth = MediaQuery.of(context).size.width;
  final width = screenWidth * .6;
  final screenHeight = MediaQuery.of(context).size.height;
  final height = screenHeight * .6;

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              width: width,
              height: height,
              padding: EdgeInsets.only(
                bottom: height * .1,
                top: height * .05,
                left: width * .05,
                right: width * .05,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: height * .1,
                    child: Text(
                      (oldMed == null) ? 'دواء جديد' : 'تعديل',
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: width * .4,
                            height: height * .1,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                TextFormField(
                                  decoration: decorateUpsertField(
                                    width: width * .4,
                                    height: height * .1,
                                    label: 'الدواء',
                                  ),
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 16,
                                  ),
                                ),
                                if (meds is LoadedMedicinesState)
                                  DropdownButton<Medicine>(
                                    isExpanded: true,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: width * .01,
                                    ),
                                    underline: const SizedBox(),
                                    onChanged: (newMed) {
                                      setState(() {
                                        selectedMed = newMed!;
                                        med.medicineId = newMed.id;
                                        med.medicineName = newMed.name;
                                        med.concentration = newMed.concentration!.toDouble();
                                        med.form = newMed.category;
                                      });
                                    },
                                    value: selectedMed,
                                    items: meds.medicines.map((m) {
                                      return DropdownMenuItem<Medicine>(
                                        alignment: Alignment.centerRight,
                                        value: m,
                                        child: Row(
                                          children: [
                                            Text(
                                              m.name!,
                                              style: const TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 18,
                                              ),
                                            ),
                                            SizedBox(width: width * .4 * .025),
                                            Text(
                                              'التركيز: ${m.concentration}',
                                              style: const TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(width: width * .4 * .025),
                                            Text(
                                              'الشكل: ${m.category}',
                                              style: const TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: height * .1),
                          SizedBox(
                            width: width * .4,
                            height: height * .1,
                            child: TextFormField(
                              initialValue: med.repeat,
                              decoration: decorateUpsertField(
                                width: width * .4,
                                height: height * .1,
                                label: 'التكرار',
                              ),
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                              ),
                              onChanged: (value) {
                                med.repeat = value;
                              },
                            ),
                          ),
                          SizedBox(height: height * .1),
                          MaterialButton(
                            onPressed: (){
                              returnFlag = true;
                              Navigator.of(context).pop();
                            },
                            height: height * .1,
                            minWidth: width * .2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: AppColors.lightGreen,
                            child: const Text(
                              'حفظ',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                color: AppColors.black
                              ),
                            ),
                          ),
                          SizedBox(height: height * .05),
                          MaterialButton(
                            onPressed: () {
                              returnFlag = false;
                              Navigator.of(context).pop();
                            },
                            height: height * .1,
                            minWidth: width * .2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: AppColors.lightGreen,
                            child: const Text(
                              'إلغاء',
                              style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 16,
                                  color: AppColors.black
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width * .4,
                            height: height * .1,
                            child: TextFormField(
                              initialValue: med.quantity,
                              decoration: decorateUpsertField(
                                width: width * .4,
                                height: height * .1,
                                label: 'الكمية',
                              ),
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                              ),
                              onChanged: (value) {
                                med.quantity = value;
                              },
                            ),
                          ),
                          SizedBox(height: height * .1),
                          Container(
                            width: width * .4,
                            height: height * .5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.black38),
                            ),
                            child: TextFormField(
                              initialValue: med.desc,
                              expands: true,
                              maxLines: null,
                              minLines: null,
                              decoration: notesDecoration,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                              ),
                              onChanged: (value) {
                                med.desc = value;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )
            );
          },
        ),
      ),
    ),
  );

  if(returnFlag){
    return med;
  }else{
    return null;
  }
}

Future<void> showConflicts(BuildContext context, WidgetRef ref) async{
  final state = ref.watch(presProvider);

  await showDialog(
    context: context,
    builder: (context) {
      final screenH = MediaQuery.of(context).size.height;
      final height = screenH * .3;
      final screenW = MediaQuery.of(context).size.width;
      final width = screenW * .4;
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
        title: const Text(
          'التعارضات الدوائية',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 22,
          ),
        ),
        titlePadding: EdgeInsets.symmetric(
          horizontal: width * .05,
          vertical: height * .03,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: width * .075,
        ),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.of(context).pop(),
            color: AppColors.black,
            height: height * .15,
            minWidth: width * .15,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Text(
              'إغلاق',
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
        content: SizedBox(
          height: height,
          width: width,
          child: state is LoadedPrescriptionState
              ? ListView.builder(
            itemCount: state.conflicts.length,
            itemBuilder: (context, index) {
            return Text(
              '${index + 1}- ${state.conflicts[index]}',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
              ),
            );
          },
          )
              : state is LoadingPrescriptionState
              ? Container(color: Colors.yellow)
              : Container(color: Colors.red),
        ),
      ),
      );
    },
  );
}
